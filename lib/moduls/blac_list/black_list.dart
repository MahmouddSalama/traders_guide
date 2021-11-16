import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/blac_list/componant/add_black_list_item.dart';
import 'package:financial_dealings/moduls/blac_list/componant/black_list_item.dart';
import 'package:financial_dealings/moduls/chats/componant/defualt_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlackListScreen extends StatefulWidget {
  @override
  _BlackListScreenState createState() => _BlackListScreenState();
}

class _BlackListScreenState extends State<BlackListScreen> {
  TextEditingController textEditingController =TextEditingController();

  late String name='';

  @override
  Widget build(BuildContext context) {
    var user=FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    return BlocProvider(
      create: (context)=>NewsCubit(),
      child: BlocConsumer<NewsCubit,NewsSates>(
        listener: (context,state){},
        builder:(context,state)  {
          return Scaffold(
          appBar:AppBar(
            title: DefaultField(
              search: (v){
                setState(() {
                  name=v;
                });
              },
              textEditingController: textEditingController,
              hint: 'search',
              elevation: 0,
              sufix:  Icon(Icons.search),
            ),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('blacklist')
                 //.orderBy('name',descending: true)
                 .where('name',isGreaterThanOrEqualTo: name)
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
                        id: snapshot.data!.docs[index].id,
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
          floatingActionButton: Builder(
            builder: (ctx)=> FloatingActionButton(
              onPressed: () {
                showBottomSheet(
                  context: ctx,
                  builder: (ctx) => AddItem(),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        );
        },
      ),
    );
  }
}
