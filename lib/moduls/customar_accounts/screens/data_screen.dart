import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DataArchifScreen extends StatelessWidget {
  final String id;
  final String colliction;
  final money;
  final payed;
  final rest;
  TextEditingController textEditingController1 = TextEditingController();

  TextEditingController textEditingController2 = TextEditingController();
   DataArchifScreen({
    Key? key,
   required this.id,
   required this.colliction,
    required this.money,
    required this.payed,
    required this.rest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ارشيف ',style: TextStyle(
          fontSize: 20,
          color: Colors.black
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [

            _buildStreamBuilder(),
            Row(
              children: [
                buildFlexible(flex: 3, text: 'التاريخ'),
                SizedBox(width: 1.5),
                buildFlexible(flex: 2, text: 'التفاصيل'),
                SizedBox(width: 1.5),
                buildFlexible(flex: 3, text: 'وارد'),
                SizedBox(width: 1.5),
                buildFlexible(flex: 3, text: 'صادر',color: Colors.red),
                SizedBox(width: 3),
                Icon(Icons.edit)
              ],
            ),
            SizedBox(height: 10),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection(colliction)
                    .doc(id)
                    .collection('archif')
                    .orderBy('createAt')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot1) {
                  try {
                    final docs1 = snapshot1.data!.docs;
                    if (snapshot1.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if (snapshot1.hasError)
                      return Text("error");
                    else if (snapshot1.hasData &&
                        snapshot1.data!.docs.length != 0) {
                      return Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 2);
                          },
                          itemCount: docs1.length,
                          itemBuilder: (context, i) {
                            return Row(
                              children: [
                                buildFlexible(
                                    flex: 3, text: snapshot1.data!.docs[i]['date']),
                                SizedBox(width: 1.5),
                                buildFlexible(
                                    flex: 2,
                                    text: snapshot1.data!.docs[i]['details']),
                                SizedBox(width: 1.5),
                                buildFlexible(
                                    flex: 3, text: snapshot1.data!.docs[i]['in']),
                                SizedBox(width: 1.5),
                                buildFlexible(
                                    color: Colors.red,
                                    flex: 3, text: snapshot1.data!.docs[i]['out']),
                                SizedBox(width: 3),
                                GestureDetector(child: Icon(Icons.edit),
                                  onTap: (){
                                    showDialog(context: context, builder: (context){
                                      return buildAlertDialog( MediaQuery.of(context).size,context,textEditingController: textEditingController1,
                                          lable: 'المبلغ الجديد',
                                          function: ()async{
                                            var cDate= await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .collection(colliction)
                                                .doc(id).get();

                                            var archifData= await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .collection(colliction)
                                                .doc(id)
                                                .collection('archif').doc(snapshot1.data!.docs[i].id).get();

                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .collection(colliction)
                                                .doc(id)
                                                .collection('archif').doc(snapshot1.data!.docs[i].id).update({
                                              'in':snapshot1.data!.docs[i]['take']==0?textEditingController1.text:'0',
                                              'out':snapshot1.data!.docs[i]['take']==1?textEditingController1.text:'0',
                                            });
                                            if(snapshot1.data!.docs[i]['take']==0){
                                              if(int.parse(textEditingController1.text)>int.parse(snapshot1.data!.docs[i]['in'])){
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(colliction)
                                                    .doc(id).update({
                                                  'payed':cDate['payed']+(int.parse(textEditingController1.text)-int.parse(archifData['in'])),
                                                  'rest': cDate['rest']-(int.parse(textEditingController1.text)-int.parse(archifData['in'])),
                                                });
                                              }else{
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(colliction)
                                                    .doc( id).update({
                                                  'payed':cDate['payed']-(int.parse(archifData['in'])-int.parse(textEditingController1.text)),
                                                  'rest': cDate['rest']+(int.parse(archifData['in'])-int.parse(textEditingController1.text)),
                                                });
                                              }
                                            }
                                            else{
                                              if(int.parse(textEditingController1.text)>int.parse(snapshot1.data!.docs[i]['in'])){
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(colliction)
                                                    .doc(id).update({
                                                  'money':'${int.parse(cDate['money'])+(int.parse(textEditingController1.text)-int.parse(archifData['out']))}',
                                                  'rest': cDate['rest']+(int.parse(textEditingController1.text)-int.parse(archifData['out'])),
                                                });
                                              }else{
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection(colliction)
                                                    .doc( id).update({
                                                  'money':'${int.parse(cDate['money'])-(int.parse(archifData['out']))-int.parse(textEditingController1.text)}',
                                                  'rest': cDate['rest']+(int.parse(archifData['out'])-int.parse(textEditingController1.text)),
                                                });
                                              }
                                            }
                                            textEditingController1.clear();
                                            Navigator.pop(context);
                                          }
                                      );
                                    });
                                  },)
                              ],
                            );
                          },
                        ),
                      );
                    } else if (snapshot1.data!.docs.length == 0) {
                      return Center(
                        child: Text('لا يوجد بيانات '),
                      );
                    }
                  } catch (e) {}
                  return Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton.extended(
          onPressed: () async {
            final user = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get();
            if (user['bloked'] == false) {
              showBottomSheet(
                context: ctx,
                builder: (ctx) {
                  return AddArchef(
                    doc:id,
                    collision: colliction,
                  );
                },
              );
            } else
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'لا يمكنك ان تقوم باي عمليه في الوقت الحالي ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blue,
              ));
          },
          label: Text('اضافه بيان'),
        ),
      ),
    );
  }

  _buildStreamBuilder()  {
    return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection(colliction)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                try {

                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Text("error");
                  else if (snapshot.hasData &&
                      snapshot.data!.docs.length != 0) {
                    final docs = snapshot.data!.docs
                        .firstWhere((element) => element.id.toString() == id);
                    return  Column(
                            children: [
                              Center(
                                  child: Text(
                                    '${docs['name']}',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  )),
                              buildColumn(
                                  edit: false,
                                  text1: 'إجمالي الصادر :  ', text2: docs['money']),
                              buildColumn(
                                  edit: false,
                                  text1: 'اجمالي الوارد :  ',
                                  text2: docs['payed'].toString()),
                              buildColumn(
                                  edit: false,
                                  text1: 'اجمالي الباقي :  ',
                                  text2: docs['rest'].toString()),
                              SizedBox(height: 10,)
                            ],
                    );
                  } else if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Text('لا يوجد بيانات '),
                    );
                  }
                } catch (e) {}
                return Center(child: CircularProgressIndicator());
              });
  }
  Flexible buildFlexibleArcif() {
    return Flexible(
      child: Container(
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(colliction)
                .doc(id)
                .collection('archif')
                .orderBy('createAt')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot1) {
              try {
                final docs1 = snapshot1.data!.docs;
                if (snapshot1.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot1.hasError)
                  return Text("error");
                else if (snapshot1.hasData &&
                    snapshot1.data!.docs.length != 0) {
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
                              flex: 3, text: snapshot1.data!.docs[i]['date']),
                          SizedBox(width: 1.5),
                          buildFlexible(
                              flex: 2,
                              text: snapshot1.data!.docs[i]['details']),
                          SizedBox(width: 1.5),
                          buildFlexible(
                              flex: 3, text: snapshot1.data!.docs[i]['in']),
                          SizedBox(width: 1.5),
                          buildFlexible(
                              color: Colors.red,
                              flex: 3, text: snapshot1.data!.docs[i]['out']),
                          SizedBox(width: 3),
                          GestureDetector(child: Icon(Icons.edit),
                            onTap: (){
                              showDialog(context: context, builder: (context){
                                return buildAlertDialog( MediaQuery.of(context).size,context,textEditingController: textEditingController1,
                                    lable: 'المبلغ الجديد',
                                    function: ()async{
                                      var cDate= await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection(colliction)
                                          .doc(id).get();

                                      var archifData= await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection(colliction)
                                          .doc(id)
                                          .collection('archif').doc(snapshot1.data!.docs[i].id).get();

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .collection(colliction)
                                          .doc(id)
                                          .collection('archif').doc(snapshot1.data!.docs[i].id).update({
                                        'in':snapshot1.data!.docs[i]['take']==0?textEditingController1.text:'0',
                                        'out':snapshot1.data!.docs[i]['take']==1?textEditingController1.text:'0',
                                      });
                                      if(snapshot1.data!.docs[i]['take']==0){
                                        if(int.parse(textEditingController1.text)>int.parse(snapshot1.data!.docs[i]['in'])){
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .collection(colliction)
                                              .doc(id).update({
                                            'payed':cDate['payed']+(int.parse(textEditingController1.text)-int.parse(archifData['in'])),
                                            'rest': cDate['rest']-(int.parse(textEditingController1.text)-int.parse(archifData['in'])),
                                          });
                                        }else{
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .collection(colliction)
                                              .doc( id).update({
                                            'payed':cDate['payed']-(int.parse(archifData['in'])-int.parse(textEditingController1.text)),
                                            'rest': cDate['rest']+(int.parse(archifData['in'])-int.parse(textEditingController1.text)),
                                          });
                                        }
                                      }
                                      else{
                                        if(int.parse(textEditingController1.text)>int.parse(snapshot1.data!.docs[i]['in'])){
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .collection(colliction)
                                              .doc(id).update({
                                            'money':'${int.parse(cDate['money'])+(int.parse(textEditingController1.text)-int.parse(archifData['out']))}',
                                            'rest': cDate['rest']+(int.parse(textEditingController1.text)-int.parse(archifData['out'])),
                                          });
                                        }else{
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .collection(colliction)
                                              .doc( id).update({
                                            'money':'${int.parse(cDate['money'])-(int.parse(archifData['out']))-int.parse(textEditingController1.text)}',
                                            'rest': cDate['rest']+(int.parse(archifData['out'])-int.parse(textEditingController1.text)),
                                          });
                                        }
                                      }
                                      textEditingController1.clear();
                                      Navigator.pop(context);
                                    }
                                );
                              });
                            },)
                        ],
                      );
                    },
                  );
                } else if (snapshot1.data!.docs.length == 0) {
                  return Center(
                    child: Text('لا يوجد بيانات '),
                  );
                }
              } catch (e) {}
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
  Flexible buildFlexible({text, flex, color=Colors.blue}) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white),
        ),
        width: 150,
        height: 35,
      ),
      flex: flex,
    );
  }
  AlertDialog buildAlertDialog(Size size, ctx,
      {required Function function,
        required TextEditingController textEditingController,required String lable}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Container(
        width: size.width,
        height: size.height * .1,
        decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DefaultTextField(
          textInputType: TextInputType.number,
          textEditingController: textEditingController,
          hint: lable,
          validetor: (v) {},
        ),
      ),
      actions: [
        TextButton(
          child: Text('تم'),
          onPressed: () {
            function();
          },
        ),
        TextButton(
          child: Text('إلغاء'),
          onPressed: () {
            Navigator.pop(ctx);
          },
        )
      ],
    );
  }
  Column buildColumn({required text1, required text2, function,required bool edit}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text1,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            edit?
            IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ):SizedBox()
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
