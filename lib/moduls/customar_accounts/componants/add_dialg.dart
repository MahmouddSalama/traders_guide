import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddCustomar extends StatefulWidget {
  final String path;

  const AddCustomar({
    required this.path,
  });

  @override
  _AddCustomarState createState() => _AddCustomarState();
}

class _AddCustomarState extends State<AddCustomar> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _dateFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  final _nameControlle = TextEditingController();
  final _addressControlle = TextEditingController();
  final _dateControlle = TextEditingController();
  final _phoneControlle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .55,
      child: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    DefaultTextField(
                      focusNode: _nameFocusNode,
                      nextFocusNode: _phoneFocusNode,
                      textEditingController: _nameControlle,
                      textInputType: TextInputType.name,
                      hint: 'الاسم',
                      validetor: (v) {
                        if (v.toString().isEmpty)
                          return 'من فضلك ادخل اسم صحيح';
                      },
                    ),
                    DefaultTextField(
                      focusNode: _phoneFocusNode,
                      nextFocusNode: _addressFocusNode,
                      textEditingController: _phoneControlle,
                      textInputType: TextInputType.phone,
                      hint: 'رقم الهاتف',
                      validetor: (v) {
                        if (v.toString().isEmpty || v.toString().length != 11)
                          return 'من فضلك ادخل رقم صحيح';
                      },
                    ),
                    DefaultTextField(
                      focusNode: _addressFocusNode,
                      nextFocusNode: _dateFocusNode,
                      textEditingController: _addressControlle,
                      textInputType: TextInputType.text,
                      hint: 'عنوان',
                      validetor: (v) {
                        if (v.toString().isEmpty )
                          return 'من فضلك ادخل عنوان صحيح';
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
                          if (v.toString().isEmpty)
                            return 'من فضلك ادخل موعد صحيح';
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : DefaultButton(
                            text: 'اضافه',
                            function: () {
                              _add();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _add() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(widget.path)
          .doc()
          .set({
        'name': _nameControlle.value.text,
        'address': _addressControlle.value.text,
        'phoneNum': _phoneControlle.value.text,
        'initMoney':"0",
        'money': "0",
        'time': _dateControlle.text,
        'createdAt': Timestamp.now(),
        'rest':0,
        'payed':0,
      }).then((value) {
        setState(() {
          loading = false;
          Navigator.pop(context);
        });
      });
    }
  }

  DateTime? picked;

  pickedDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateControlle.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        //_timestamp=Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch,);
      });
    }
  }
}
