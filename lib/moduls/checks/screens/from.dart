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
        actions: [
          IconButton(
              onPressed: () {
                Methods.Navplace(page: NotificationsScreen(), ctx: context);
              },
              icon: Icon(
                Icons.notifications,
              )),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.search,
          //     )),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('checks')
                .orderBy('createdAt',descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              try{
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
                        id: snapshot.data!.docs[index].id,
                        name: snapshot.data!.docs[index]['from'],
                        index: index,
                        delete: (){
                          showDialog(context: ctx, builder:(ctx)=> AlertDialog(
                            content:Text('هل تريد مسح العمل حقا ؟') ,
                            actions: [
                              TextButton(onPressed: (){
                                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("checks")
                                    .doc("${snapshot.data!.docs[index].id}").delete();
                              }, child: Text('نهم')),
                              TextButton(onPressed: (){
                                Navigator.pop(ctx);
                              }, child: Text('لا'))
                            ],
                          ));
                        },
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                } else if (snapshot.data!.docs.length==0) {
                  return Center(
                    child: Text('لا يوجد شيكات'),
                  );
                }
              }catch(e){

              }
              return Center(child:CircularProgressIndicator());
                },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(context: context, builder: (context) => AddCheck());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
