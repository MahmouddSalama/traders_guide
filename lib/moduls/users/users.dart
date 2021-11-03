import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/users/user_information.dart';
import 'package:flutter/material.dart';

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [

        ],
        centerTitle: true,
        title: Text(
          'المستخدمين',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').orderBy('createdAt').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              try{
                final docs = snapshot.data!.docs;
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError)
                  return Text("error");
                else if (snapshot.hasData &&
                    snapshot.data!.docs.length != 0){
                  return ListView.separated(
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data!.docs[index]['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]['imageUrl']
                          )
                        ),
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (ctx) => UserInfo(id: snapshot.data!.docs[index].id,)));
                        },
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return Divider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }
                else if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text('لا يوجد عملاء '),
                  );
                }
              }catch(e){}
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
