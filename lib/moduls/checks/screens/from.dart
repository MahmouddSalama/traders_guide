import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/checks/componant/add_check.dart';
import 'package:financial_dealings/moduls/checks/componant/check_card.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/customar_card.dart';
import 'package:financial_dealings/screens/notifications_screen/notification_screen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class From extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الشيكات',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('checks')
                .orderBy('createdAt', descending: false)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              try {
                final docs = snapshot.data!.docs;
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError)
                  return Text("error");
                else if (snapshot.hasData) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return CheckCard(
                        date: snapshot.data!.docs[index]['dueDate'] ,
                        id: snapshot.data!.docs[index].id,
                        name: snapshot.data!.docs[index]['from'],
                        index: index,
                        delete: () {
                          showDialog(
                              context: ctx,
                              builder: (ctx) => AlertDialog(
                                    content: Text('هل تريد مسح العمل حقا ؟'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("checks")
                                                .doc(
                                                    "${snapshot.data!.docs[index].id}")
                                                .delete();
                                            Navigator.pop(ctx);
                                          },
                                          child: Text('نعم')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                          },
                                          child: Text('لا'))
                                    ],
                                  ),
                          );
                        },
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                } else if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text('لا يوجد شيكات'),
                  );
                }
              } catch (e) {}
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Builder(
        builder: (ctx)=> FloatingActionButton(
          onPressed: () async {
            final user = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            if (user['bloked'] == false) {
              showBottomSheet(context: ctx, builder: (ctx) => AddCheck());
            } else
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                    'لا يمكنك ان تقوم باي عمليه في الوقت الحالي ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
