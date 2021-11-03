import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:financial_dealings/moduls/customar_accounts/model/customer.dart';
import 'package:financial_dealings/moduls/customar_accounts/provider/customer_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerInformation extends StatelessWidget {
  final int index;
  final Color color;
  //final Customer customer;
  final id;
  final String collision;

  const CustomerInformation({
    Key? key,
    required this.id,
    required this.index,
    required this.color,
   // required this.customer,
    required this.collision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<MyProvider>(
      create: (context) => MyProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * .2,
              color: color,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(collision)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  try {
                    final docs = snapshot.data!.docs
                        .firstWhere((element) => element.id.toString() == id);
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if (snapshot.hasError)
                      return Text("error");
                    else if (snapshot.hasData &&
                        snapshot.data!.docs.length != 0) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Expanded(
                          child: Container(
                            height: size.height - size.height * .14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30)),
                            ),
                            //height: size.height * .75,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: Column(
                                children: [
                                  buildColumn(
                                      text1: 'الاسم :  ', text2: docs['name']),
                                  buildColumn(
                                      text1: 'رقم الهاتف :  ',
                                      text2: docs['phoneNum']),
                                  buildColumn(
                                      text1: 'الرقم القومي :  ',
                                      text2: docs['ip']),
                                  buildColumn(
                                      text1: ' العنوان :  ',
                                      text2: docs['address']),
                                  buildColumn(
                                      text1: 'المبلغ :  ',
                                      text2: '${docs['money']} ج'),
                                  buildColumn(
                                      text1: 'المعاد :  ', text2: docs['time']),
                                  Center(
                                      child: Text(
                                    'الارشيف',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Row(
                                    children: [
                                      buildFlexible(flex: 2, text: 'التاريخ'),
                                      SizedBox(width: 5),
                                      buildFlexible(flex: 1, text: 'التفاصيل'),
                                      SizedBox(width: 5),
                                      buildFlexible(flex: 1, text: 'وارد'),
                                      SizedBox(width: 5),
                                      buildFlexible(flex: 1, text: 'باقي')
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  buildFlexibleArcif()
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.data!.docs.length == 0) {
                      return Center(
                        child: Text('لا يوجد عملاء مدينون'),
                      );
                    }
                  } catch (e) {}
                  return Center(child: Text('fff'));
                }),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton.extended(
            onPressed: () {
              showBottomSheet(
                context: ctx,
                builder: (ctx) {
                  return AddArchef(
                    doc: id,
                    collision: collision,
                  );
                },
              );
            },
            label: Text('اضافه ارشيف'),
          ),
        ),
      ),
    );
  }

  Flexible buildFlexibleArcif() {
    return Flexible(
      child: Container(
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance.collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(collision)
                .doc(id)
                .collection('archif').orderBy('createAt')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot1) {
              try {
                final docs1 = snapshot1.data!.docs;
                if (snapshot1.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot1.hasError)
                  return Text("error");
                else if (snapshot1.hasData && snapshot1.data!.docs.length != 0)
                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return Divider(thickness: 2);
                    },
                    itemCount: docs1.length,
                    itemBuilder: (context, i) {
                      return Row(
                        children: [
                          buildFlexible(
                              flex: 2, text: snapshot1.data!.docs[i]['date']),
                          SizedBox(width: 5),
                          buildFlexible(
                              flex: 1,
                              text: snapshot1.data!.docs[i]['details']),
                          SizedBox(width: 5),
                          buildFlexible(
                              flex: 1, text: snapshot1.data!.docs[i]['in']),
                          SizedBox(width: 5),
                          buildFlexible(
                              flex: 1, text: snapshot1.data!.docs[i]['out'])
                        ],
                      );
                    },
                  );
                else if (snapshot1.data!.docs.length == 0) {
                  return Center(
                    child: Text('لا يوجد ارشيف '),
                  );
                }
              } catch (e) {}
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Flexible buildFlexible({text, flex}) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
        ),
        width: 150,
        height: 35,
      ),
      flex: flex,
    );
  }

  Column buildColumn({required text1, required text2}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Divider(
          thickness: 2,
          color: Colors.blue.shade100,
        ),
      ],
    );
  }
}
