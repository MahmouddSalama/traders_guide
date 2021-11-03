import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_dialg.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/customar_card.dart';
import 'package:financial_dealings/moduls/customar_accounts/model/customer.dart';
import 'package:financial_dealings/moduls/customar_accounts/provider/customer_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Owe extends StatelessWidget {
  late Customer customer;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('owecustomers')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                try {
                  Provider.of<MyProvider>(context,listen: false).customerCreditList.clear();
                  for(int index=0;index<snapshot.data!.docs.length;index++){
                    customer = Customer(
                      name: snapshot.data!.docs[index]['name'].toString(),
                      phone: snapshot.data!.docs[index]['phoneNum'].toString(),
                      ip: snapshot.data!.docs[index]['ip'].toString(),
                      money: int.parse(snapshot.data!.docs[index]['money']),
                      date: snapshot.data!.docs[index]['time'].toString(),
                      archef: snapshot.data!.docs[index]['archif'],
                    );
                    if(Provider.of<MyProvider>(context,listen: false).customerCreditList.contains(customer)==false)
                    {
                      Provider.of<MyProvider>(context,listen: false).addCustomerCredit(customer: customer);
                      print(Provider.of<MyProvider>(context,listen: false).customerCreditList.length);
                    }
                  }
                  final docs = snapshot.data!.docs;
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Text("error");
                  else if (snapshot.hasData &&
                      snapshot.data!.docs.length != 0) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return CustomerCard(
                          rest: snapshot.data!.docs[index]['rest'],
                          collision: 'owecustomers',
                          id: snapshot.data!.docs[index].id,
                          //customer: Provider.of<MyProvider>(ctx,listen: false).customerCreditList[index],
                          name: snapshot.data!.docs[index]['name'].toString(),
                          delete: () {
                            showDialog(context: ctx, builder:(ctx)=> AlertDialog(
                              content:Text('هل تريد مسح العميل حقا ؟') ,
                              actions: [
                                TextButton(onPressed: (){
                                  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                                      .collection("owecustomers")
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                  Provider.of<MyProvider>(ctx,listen: false).deletCridet(index);
                                }, child: Text('نهم')),
                                TextButton(onPressed: (){
                                  Navigator.pop(ctx);
                                }, child: Text('لا'))
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
                      child: Text('لا يوجد عملاء دائنون'),
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
                path: 'owecustomers',
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
