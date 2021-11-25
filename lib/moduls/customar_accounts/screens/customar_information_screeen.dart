import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/add_archef.dart';
import 'package:financial_dealings/moduls/customar_accounts/screens/data_screen.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomerInformation extends StatefulWidget {
  final int index;
  final Color color;
  final id;
  final String collision;


  CustomerInformation({
    Key? key,
    required this.id,
    required this.index,
    required this.color,
    // required this.customer,
    required this.collision,
  }) : super(key: key);

  @override
  _CustomerInformationState createState() => _CustomerInformationState();
}

class _CustomerInformationState extends State<CustomerInformation> {
  TextEditingController textEditingController1 = TextEditingController();

  TextEditingController textEditingController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * .5,
            color: widget.color,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(widget.collision)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              try {
                final docs = snapshot.data!.docs
                    .firstWhere((element) =>
                element.id.toString() == widget.id);
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else if (snapshot.hasError)
                  return Text("error");
                else if (snapshot.hasData && snapshot.data!.docs.length != 0) {
                  var cutomerData = FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth
                      .instance.currentUser!.uid)
                      .collection(widget.collision)
                      .doc(widget.id);
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Expanded(
                      child: Container(
                        height: size.height - size.height * .15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                        ),
                        //height: size.height * .75,
                        child: Padding(
                          padding:
                          EdgeInsets.only(top: 10, right: 20, left: 20),
                          child: Column(
                            children: [
                              buildColumn(
                                  edit: true,
                                  text1: 'الاسم :  ', text2: docs['name'],
                                  function: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(size, context,
                                            lable: 'الاسم',
                                            function: () async {
                                              await cutomerData
                                                  .update({
                                                'name': textEditingController1
                                                    .text,
                                              },
                                              );
                                              textEditingController1.clear();
                                              Navigator.pop(context);
                                            },
                                            textEditingController: textEditingController1);
                                      },
                                    );
                                  }
                              ),

                              buildColumn(
                                  edit: true,
                                  text1: 'رقم الهاتف :  ',
                                  text2: docs['phoneNum'],
                                  function: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(size, context,
                                            textinput: TextInputType.phone,
                                            lable: 'رقم الهاتف',
                                            function: () async {
                                              await cutomerData
                                                  .update({
                                                'phoneNum': textEditingController1
                                                    .text,
                                              },
                                              );
                                              textEditingController1.clear();
                                              Navigator.pop(context);
                                            },
                                            textEditingController: textEditingController1);
                                      },
                                    );
                                  }
                              ),
                              buildColumn(
                                  edit: true,
                                  text1: ' العنوان :  ',
                                  text2: docs['address'],
                                  function: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return buildAlertDialog(size, context,
                                            lable: 'العنوان',
                                            function: () async {
                                              await cutomerData
                                                  .update({
                                                'address': textEditingController1
                                                    .text,
                                              },
                                              );
                                              textEditingController1.clear();
                                              Navigator.pop(context);
                                            },
                                            textEditingController: textEditingController1);
                                      },
                                    );
                                  }),
                              // buildColumn(text1: 'المبلغ :  ', text2: '${docs['money']} ج'),
                              buildColumn(
                                  edit: true,
                                  text1: 'المعاد :  ', text2: docs['time'],
                                  function: () async {
                                    await pickedDialog(field: 'time');
                                  }),
                              buildColumn(
                                  edit: false,
                                  text1: 'إجمالي الصادر :  ',
                                  text2: docs['money']),
                              buildColumn(
                                  edit: false,
                                  text1: 'اجمالي الوارد :  ',
                                  text2: docs['payed'].toString()),
                              buildColumn(
                                  edit: false,
                                  text1: 'اجمالي الباقي :  ',
                                  text2: docs['rest'].toString(),
                              x:docs['rest'] ),
                              SizedBox(height: 20,),
                              DefaultButton(
                                function: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (_) =>
                                      DataArchifScreen(
                                        payed: "",
                                        money: "",
                                        rest: "",
                                        id: widget.id,
                                        colliction: widget.collision,
                                      )));
                                },
                                text: 'البيانات',
                              )
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
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  AlertDialog buildAlertDialog(Size size, ctx,
      {required Function function,
        required TextEditingController textEditingController, required String lable,
        textinput = TextInputType.text
      }) {
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
          textInputType: textinput,
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

  Column buildColumn(
      {required text1, required text2, function, required bool edit, int x=1,}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              text1,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500,
                  color:x>0?Colors.black:Colors.red),
            ),
            Text(
              text2,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color:x>0?Colors.black:Colors.red),
            ),
            Spacer(),
            edit ?
            IconButton(
              onPressed: () {
                function();
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ) : SizedBox()
          ],
        ),
        Divider(
          thickness: 2,
          color: Colors.blue.shade100,
        ),
      ],
    );
  }

  DateTime? picked;

  pickedDialog({required String field}) async {
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
          .collection(widget.collision)
          .doc(widget.id)
          .update({
        field: '${picked!.year}-${picked!.month}-${picked!.day}',
      },
      );
    }
  }
}
