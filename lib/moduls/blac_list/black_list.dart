import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/blac_list/componant/add_black_list_item.dart';
import 'package:financial_dealings/moduls/blac_list/componant/black_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlackListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
        elevation: 0,
        title: Text(
          'القائمة السوداء',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blacklist').snapshots(),
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
                itemBuilder: (context, index) {
                  return BlackListItem(
                    delete: () async {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                content: Text('هل تريد مسح  حقا ؟'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        var userid = await FirebaseFirestore.instance.collection("blacklist").doc("${snapshot.data!.docs[index].id}").get();
                                        var user=await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                                        if (userid['userId'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid||user['admin']) {
                                          await FirebaseFirestore.instance
                                              .collection("blacklist")
                                              .doc(
                                                  "${snapshot.data!.docs[index].id}")
                                              .delete();
                                          Navigator.pop(ctx);
                                        }
                                      },
                                      child: Text('نعم')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      child: Text('لا'))
                                ],
                              ));
                    },
                    name: snapshot.data!.docs[index]['name'],
                    imageUrl: snapshot.data!.docs[index]['imageUrl'],
                    address: snapshot.data!.docs[index]['address'],
                    debartment: snapshot.data!.docs[index]['trak'],
                  );
                },
              );
            } else if (snapshot.data!.docs.length==0) {
              return Center(
                child: Text('لا يوجد شيكات'),
              );
            }
          } catch (e) {}
          return Center(
            child:
                CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) => AddItem(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
