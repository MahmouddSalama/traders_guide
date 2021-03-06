import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/chats/componant/defualt_field.dart';
import 'package:financial_dealings/moduls/users/user_information.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  TextEditingController textEditingController = TextEditingController();
  late String name='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'المستخدمين',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          DefaultField(
            search: (v) {
              setState(() {
                name = v;
              });
            },
            textEditingController: textEditingController,
            hint: 'search',
            elevation: 0,
            sufix: Icon(Icons.search),
          ),
          Container(
            child:Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('name',isGreaterThanOrEqualTo: name)
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
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'عدد المستخدمين',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data!.docs.length}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                child: Expanded(
                                  child: ListView.separated(
                                    itemBuilder: (ctx, index) {
                                      return ListTile(
                                        title: Text(
                                          snapshot.data!.docs[index]['name'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        leading: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      width: 200,
                                                      height: 250,
                                                      child: Image.network(
                                                        snapshot.data!.docs[index]
                                                            ['imageUrl'],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(20)),
                                                  );
                                                });
                                          },
                                          child: CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(snapshot
                                                  .data!.docs[index]['imageUrl'])),
                                        ),
                                        trailing: Text(
                                          snapshot.data!.docs[index]['bloked']
                                              ? 'فك الحظر'
                                              : 'حظر',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.grey),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (ctx) => UserInfo(
                                                        id: snapshot
                                                            .data!.docs[index].id,
                                                      )));
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
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.data!.docs.length == 0) {
                          return Center(
                            child: Text('لا يوجد عملاء '),
                          );
                        }
                      } catch (e) {}
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
