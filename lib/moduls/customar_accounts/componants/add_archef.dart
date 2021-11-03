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

  final _moneyControlle = TextEditingController();

  final _dateControlle = TextEditingController();

  final _typeControlle = TextEditingController();

  final _remnderControlle = TextEditingController();

  FocusNode _moneyFocusNode = FocusNode();

  FocusNode _remederFocusNode = FocusNode();

  FocusNode _dateFocusNode = FocusNode();

  FocusNode _typeFocusNode = FocusNode();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .45,
      child: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                // DefaultTextField(
                //   focusNode: _remederFocusNode,
                //   nextFocusNode: _typeFocusNode,
                //   textEditingController: _remnderControlle,
                //   textInputType: TextInputType.number,
                //   hint: 'المبلغ الباقي',
                //   validetor: (v) {
                //     if (v.toString().isEmpty) return 'من فضلك ادخل عنوان صحيح';
                //   },
                // ),
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
                SizedBox(height: 30),
                DefaultButton(
                  text: 'اضافه',
                  function: () {
                    _add();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _add() async {
    print(widget.doc);
    print(widget.collision);
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
      'in': int.parse(_moneyControlle.text).toString(),
      'out': (rem - int.parse(_moneyControlle.text)).toString(),
      'details': _typeControlle.text,
      'createAt': Timestamp.now(),
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(widget.collision)
          .doc(widget.doc)
          .update({
        'rest': rem - int.parse(_moneyControlle.text)}).then(
              (value) {
        setState(() {
          loading = false;
          Navigator.pop(context);
        });
      });
    });
  }

  DateTime? picked;

  pickedDialog() async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    if (picked != null) {
      setState(() {
        _dateControlle.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        //_timestamp=Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch,);
      });
    }
  }
}
