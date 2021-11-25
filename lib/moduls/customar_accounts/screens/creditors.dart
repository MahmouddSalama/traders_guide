import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_dialg.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/customar_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Creditors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('Creditcustomers')
                .orderBy('createdAt')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              try {
                final docs = snapshot.data!.docs;
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError)
                  return Text("error");
                else if (snapshot.hasData && snapshot.data!.docs.length != 0) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return CustomerCard(
                        rest: snapshot.data!.docs[index]['rest'],
                        collision: 'Creditcustomers',
                        id: snapshot.data!.docs[index].id,
                        name: snapshot.data!.docs[index]['name'].toString(),
                        delete: () {
                          showDialog(
                              context: ctx,
                              builder: (ctx) => AlertDialog(
                                    content: Text('هل تريد مسح العميل حقا ؟'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("Creditcustomers")
                                                .doc(snapshot
                                                    .data!.docs[index].id)
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
                                  ));
                        },
                        index: index,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                } else if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text('لا يوجد عملاء مدينون'),
                  );
                }
              } catch (e) {}
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) => AddCustomar(
              path: 'Creditcustomers',
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
