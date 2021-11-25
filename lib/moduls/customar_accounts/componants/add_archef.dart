import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddArchef extends StatefulWidget {
  final String collision;
  final String doc;

  AddArchef({
    Key? key,
    required this.collision,
    required this.doc,
  }) : super(key: key);

  @override
  _AddArchefState createState() => _AddArchefState();
}

class _AddArchefState extends State<AddArchef> {
  int index = 0;
  int rValue=0;
  final _moneyControlle = TextEditingController();

  final _dateControlle = TextEditingController();

  final _typeControlle = TextEditingController();

  FocusNode _moneyFocusNode = FocusNode();

  FocusNode _dateFocusNode = FocusNode();

  FocusNode _typeFocusNode = FocusNode();

  bool loading = false;
  var _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .4,
      child: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DefaultTextField(
                      focusNode: _moneyFocusNode,
                      nextFocusNode: _typeFocusNode,
                      textEditingController: _moneyControlle,
                      textInputType: TextInputType.number,
                      hint: 'المبلغ',
                      validetor: (v) {
                        if (v.toString().isEmpty) return 'من فضلك ادخل عنوان صحيح';
                      },
                    ),
                    DefaultTextField(
                      focusNode: _typeFocusNode,
                      nextFocusNode: _dateFocusNode,
                      textEditingController: _typeControlle,
                      textInputType: TextInputType.text,
                      hint: 'النوع',
                      validetor: (v) {
                        if (v.toString().isEmpty) return 'من فضلك ادخل نوع صحيح';
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        pickedDialog();
                      },
                      child: DefaultTextField(
                        enabled: false,
                        focusNode: _dateFocusNode,
                        textEditingController: _dateControlle,
                        textInputType: TextInputType.phone,
                        hint: 'المعاد',
                        validetor: (v) {
                          if (v.toString().isEmpty) return 'من فضلك ادخل موعد صحيح';
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                              fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                              value: 0,
                              groupValue: rValue,
                              onChanged: (v){
                                setState(() {
                                  rValue=int.parse(v.toString());
                                });
                              },
                            ),
                            Text('وارد',style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            ),),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                              value: 1,
                              groupValue: rValue,
                              onChanged: (v){
                                setState(() {
                                  rValue=int.parse(v.toString());
                                });
                              },
                            ),
                            Text('صادر',style: TextStyle(
                                color: Colors.white,
                                fontSize: 25
                            ),),
                          ],
                        ),
                      ],
                    ),
                    DefaultButton(
                      text: 'اضافه',
                      function: () {
                        _add();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _add() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        loading = true;
      });
      var ar = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(widget.collision)
          .doc(widget.doc)
          .get();
      int rem = ar['rest'];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(widget.collision)
          .doc(widget.doc)
          .collection('archif')
          .doc()
          .set({
        'date': _dateControlle.text,
        'out':rValue==1?int.parse(_moneyControlle.text).toString():'0',
        'in':rValue==0 ?int.parse(_moneyControlle.text).toString():'0',
        'details': _typeControlle.text,
        'createAt': picked,
        'take':rValue,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(widget.collision)
            .doc(widget.doc)
            .update({
          'payed':rValue==0?ar['payed']+int.parse(_moneyControlle.text):ar['payed']+0,
          'rest':rValue==0? rem - int.parse(_moneyControlle.text):rem + int.parse(_moneyControlle.text),
          'money':rValue==1?(int.parse(ar['money'])+int.parse(_moneyControlle.text)).toString():ar['money']
        }).then(
                (value) {
              setState(() {
                loading = false;
                Navigator.pop(context);
              });
            },
        );
      });
    }
  }

  DateTime? picked;

  pickedDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 50)),
      lastDate: DateTime.now().add(Duration(days: 50)),
    );
    if (picked != null) {
      setState(() {
        _dateControlle.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        //_timestamp=Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch,);
      });
    }
  }
}
