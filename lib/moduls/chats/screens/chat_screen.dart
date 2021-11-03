import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/chats/componant/defualt_field.dart';
import 'package:financial_dealings/moduls/chats/componant/message_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'الدردشة الجماعيه',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chat')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (_, AsyncSnapshot snapShot) {
                    try {
                      final docs = snapShot.data!.docs;
                      if (snapShot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else if (snapShot.hasError)
                        return Text("error");
                      else if (snapShot.hasData) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(
                              message: docs[index]['text'],
                              username: docs[index]['username'],
                              isme: docs[index]['userID'] ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              key: ValueKey(docs[index]),
                              imageurl: docs[index]['userImage'],
                            );
                          },
                        );
                      }
                    } catch (r) {
                      print(r);
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  FloatingActionButton(
                    backgroundColor: Color(0xff002A4D),
                    onPressed: () {
                      if(textEditingController.text!='')
                      send();
                    },
                    child: Icon(
                      Icons.send,
                      textDirection: TextDirection.ltr,
                    ),
                    mini: true,
                  ),
                  Expanded(
                    child: DefaultField(
                      hint: 'اكتب رسالتك....',
                      elevation: 0,
                      textEditingController: textEditingController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  send() async {
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection("users").doc(
        user!.uid).get();
    await FirebaseFirestore.instance.collection('chat').add({
      'text': '${textEditingController.text}',
      'time': Timestamp.now(),
      'username': userData['name'],
      'userID': user.uid,
      'userImage':userData['imageUrl'],
    });
    textEditingController.clear();
  }
}
