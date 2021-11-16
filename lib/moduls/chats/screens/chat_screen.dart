import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/chats/componant/defualt_field.dart';
import 'package:financial_dealings/moduls/chats/componant/message_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final TextEditingController textEditingController = TextEditingController();
  bool loading  =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                              isImage: docs[index]['isImage'],
                              message: docs[index]['text'],
                              username: docs[index]['username'],
                              isme: docs[index]['userID'] ==
                                  FirebaseAuth.instance.currentUser!.uid,
                              key: ValueKey(docs[index]),
                              imageurl: docs[index]['userImage'],
                              time:  docs[index]['time'],
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
                       send();
                    },
                    child:loading?CircularProgressIndicator(): Icon(
                      Icons.send,
                      textDirection: TextDirection.ltr,
                    ),
                    mini: true,
                  ),
                  Expanded(
                    child:image==null ?DefaultField(
                      search: (v){},
                      sufix: IconButton(
                        icon: Icon(Icons.image),
                        onPressed: (){
                          print('catch camera');
                          _showPhotoDialog();
                        },
                      ),
                      hint: 'اكتب رسالتك....',
                      elevation: 0,
                      textEditingController: textEditingController,
                    ):
                    Container(
                      height: 150,
                      width: 150,
                      child: Image.file(
                        image!,
                        fit: BoxFit.fill,
                      ),
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
    String? imageurl;
    late final  url;
    if(image!=null){
      setState(() {
        loading=true;
      });
      final ref = await FirebaseStorage.instance
          .ref()
          .child('chatImages')
          .child(Uuid().v1()+'.jpg');
      await ref.putFile(image!);
      url = await ref.getDownloadURL();
      setState(() {
        loading=false;
      });
    }
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection("users").doc(
        user!.uid).get();
    await FirebaseFirestore.instance.collection('chat').add({
      'isImage':image!=null,
      'text': image!=null?url:'${textEditingController.text}',
      'time': Timestamp.now(),
      'username': userData['name'],
      'userID': user.uid,
      'userImage':userData['imageUrl'],
    });
    setState(() {
      image=null;
    });
    textEditingController.clear();
  }

  File? image;
  _showPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اختار صوره من'),
        content: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.blue,
                  size: 25,
                ),
                label: Text(
                  'المعرض',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: 25,
                ),
                label: Text(
                  'الكاميرا',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('اغلاق'))
        ],
      ),
    );
  }

  final picker = ImagePicker();

  Future getImage(ImageSource crs) async {
    final pickerFile = await picker.pickImage(source: crs);
    setState(() {
      if (pickerFile != null) {
        image = File(pickerFile.path);
      } else {
        print('No photo');
      }
    });
  }
}
