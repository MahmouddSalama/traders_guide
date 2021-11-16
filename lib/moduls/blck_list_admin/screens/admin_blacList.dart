import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/blac_list/componant/black_list_item.dart';
import 'package:financial_dealings/moduls/blck_list_admin/componant/black_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AdminBlackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin_blacklist').snapshots(),
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
                  return  AdminBlackListItem(
                    id: docs[index].id,
                  );
                },
              );
            } else if (snapshot.data!.docs.length==0) {
              return Center(
                child: Text('لا يوجد '),
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
    );
  }
}
