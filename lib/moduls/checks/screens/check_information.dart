import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/checks/componant/add_check.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckInformation extends StatefulWidget {
  final id, color;

  CheckInformation({
    Key? key,
    required this.id,
    required this.color,
  }) : super(key: key);

  @override
  _CheckInformationState createState() => _CheckInformationState();
}

class _CheckInformationState extends State<CheckInformation> {
  TextEditingController textEditingController1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * .3,
            color: widget.color,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('checks')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                try {
                  final docs = snapshot.data!.docs
                      .firstWhere((element) => element.id.toString() == widget.id);
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else if (snapshot.hasError)
                    return Text("error");
                  else if (snapshot.hasData &&
                      snapshot.data!.docs.length != 0) {
                      var checkData= FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth
                        .instance.currentUser!.uid)
                        .collection('checks')
                        .doc(widget.id);
                    return Align(
                      alignment: Alignment(0, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        height: size.height * .9,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 10, right: 20, left: 20),
                          child: Column(
                            children: [
                              buildColumn(
                                text1: 'الشيك من :  ',
                                text2: docs['from'],
                                function: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(size, context,
                                            label: 'الشيك من',
                                            function: () async {
                                          await checkData
                                              .update({
                                              'from': textEditingController1.text,
                                            },
                                          );
                                          textEditingController1.clear();
                                          Navigator.pop(context);
                                        }, textEditingController: textEditingController1);
                                      },
                                  );
                                },
                              ),
                              buildColumn(
                                text1: 'الشيك إلي :  ',
                                text2: docs['to'],
                                function: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(size, context,
                                           label: 'الشيك إلي',
                                            function: () async {
                                              await checkData
                                              .update({
                                              'to': textEditingController1.text,
                                            },
                                          );
                                          textEditingController1.clear();
                                          Navigator.pop(context);
                                        },textEditingController: textEditingController1);
                                      });
                                },
                              ),
                              buildColumn(
                                text1: 'المعاد المستحق :  ',
                                text2: docs['dueDate'],
                                function: ()async {
                                await  pickedDialog(field: 'dueDate');
                                },
                              ),
                              buildColumn(
                                text1: 'المعاد السداد :  ',
                                text2: docs['dateOfPayment'],
                                function: ()async {
                                  await  pickedDialog(field: 'dateOfPayment');
                                },
                              ),
                              buildColumn(
                                text1: 'المبلغ :  ',
                                text2: '${docs['money']} ج',
                                function: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(size, context,
                                            label: 'المبلغ الجديد',
                                            function: () async {
                                              await checkData
                                                  .update({
                                                'money': textEditingController1.text,
                                              },
                                              );
                                              textEditingController1.clear();
                                              Navigator.pop(context);
                                            },textEditingController: textEditingController1);
                                      });
                                },
                              ),
                              //buildColumn(text1: 'تم التسديد :  ', text2: docs['paid']?'نعم':'لا'),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'تم التسديد :  ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        docs['paid'] ? 'نعم' : 'لا',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: docs['paid'],
                                        onChanged: (v) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection('checks')
                                              .doc(widget.id)
                                              .update({
                                            'paid': v,
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.blue.shade100,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'تم الرفض من البنك :  ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        docs['rejected '] ? 'نعم' : 'لا',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: docs['rejected '],
                                        onChanged: (v) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection('checks')
                                              .doc(widget.id)
                                              .update({
                                            'rejected ': v,
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.blue.shade100,
                                  ),
                                ],
                              ),
                            ],
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
    );
  }

  Column buildColumn({required text1, required text2, required function}) {
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
            Spacer(),
            IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            )
          ],
        ),
        Divider(
          thickness: 2,
          color: Colors.blue.shade100,
        ),
      ],
    );
  }

  AlertDialog buildAlertDialog(Size size, ctx,
      {required Function function,
      required TextEditingController textEditingController,required String label}) {
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
          textInputType: TextInputType.text,
          textEditingController: textEditingController,
          hint: label,
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

  DateTime? picked;

  pickedDialog({required String field} ) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 350)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth
          .instance.currentUser!.uid)
          .collection('checks')
          .doc(widget.id)
          .update({
        field: '${picked!.year}-${picked!.month}-${picked!.day}',
      },
      );

    }
  }
}
