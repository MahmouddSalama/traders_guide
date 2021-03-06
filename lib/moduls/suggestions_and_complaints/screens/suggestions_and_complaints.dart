import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/suggestions_and_complaints/componant/suggestions_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SuggestionsAndComplaints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('SuggestionsAndComplaints')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          try {
            final docs = snapshot.data!.docs;
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Text("error");
            else if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (ctx)=>OrderDetails()));
                          },
                          child: Container(
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        buildRow(
                                            text1: '??????????  : ',
                                            text2: snapshot.data!.docs[index]
                                                ['name']),
                                        buildRow(
                                            text1: '??????????????   : ',
                                            text2:
                                                '${snapshot.data!.docs[index]['supject']}')
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  color: Colors.black.withOpacity(.6),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Center(
                                          child: Text(
                                            '?????????? ??????????????',
                                            style: TextStyle(
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data!.docs[index]['message']}',
                                          style: TextStyle(fontSize: 17),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-1, -1),
                        child: IconButton(
                          onPressed: ()async {
                            var user = await FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(FirebaseAuth
                                .instance.currentUser!.uid)
                                .get();
                            if (user['admin'])
                            showDialog(
                              context: ctx,
                              builder: (ctx) => AlertDialog(
                                content: Text('???? ???????? ?????? ?????????????? ?????? ??'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                          FirebaseFirestore.instance
                                              .collection(
                                                  "SuggestionsAndComplaints")
                                              .doc(
                                                  "${snapshot.data!.docs[index].id}")
                                              .delete();
                                          Navigator.pop(ctx);
                                      },
                                      child: Text('??????')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text('????'))
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            } else if (docs.isEmpty) {
              return Center(
                child: Text('???? ???????? ?????????????? ???? ??????????'),
              );
            }
          } catch (e) {}
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Row buildRow({text1, text2}) {
    return Row(
      children: [
        Text(
          text1,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          text2,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
