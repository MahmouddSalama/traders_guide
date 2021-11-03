import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';





class AddCheck extends StatefulWidget {
  @override
  _AddCheckState createState() => _AddCheckState();
}

class _AddCheckState extends State<AddCheck> {
  bool loading=false;
  FocusNode _fromFocusNode = FocusNode();
  FocusNode _toFocusNode = FocusNode();
  FocusNode _dateOfPaymentFocusNode = FocusNode();
  FocusNode _dueDateFocusNode = FocusNode();
  FocusNode _moneyFocusNode = FocusNode();

  final _moneyControlle = TextEditingController();
  final _fromControlle = TextEditingController();
  final _toControlle = TextEditingController();
  final _dateOfPaymenControlle = TextEditingController();
  final _dueDateControlle = TextEditingController();

  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * .5,
        child: Stack(
          children: [
            BackgroundAnimationImage(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Form(
                    key:_formKey ,
                    child: Column(
                      children: [
                        DefaultTextField(
                          focusNode: _fromFocusNode,
                          nextFocusNode: _toFocusNode,
                          textEditingController: _fromControlle,
                          textInputType: TextInputType.streetAddress,
                          hint: 'الشيك من',
                          validetor: (v) {
                            if (v.toString().isEmpty)
                              return 'من فضلك ادخل الاسم صحيح';
                          },
                        ),
                        DefaultTextField(
                          focusNode: _toFocusNode,
                          nextFocusNode: _moneyFocusNode,
                          textEditingController: _toControlle,
                          textInputType: TextInputType.name,
                          hint: 'الشيك إلي',
                          validetor: (v) {
                            if (v.toString().isEmpty)
                              return 'من فضلك ادخل الاسم صحيح';
                          },
                        ),
                        DefaultTextField(
                          focusNode: _moneyFocusNode,
                          nextFocusNode: _dueDateFocusNode,
                          textEditingController: _moneyControlle,
                          textInputType: TextInputType.number,
                          hint: 'المبلغ',
                          validetor: (v) {
                            if (v.toString().isEmpty)
                              return 'من فضلك ادخل رقم صحيح';
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            pickedDialog(control: _dueDateControlle);
                          },
                          child: DefaultTextField(
                            enabled: false,
                            focusNode: _dueDateFocusNode,
                            nextFocusNode: _dateOfPaymentFocusNode,
                            textEditingController: _dueDateControlle,
                            textInputType: TextInputType.phone,
                            hint: 'المعاد الاستحقاق',
                            validetor: (v) {
                              if (v.toString().isEmpty)
                                return 'من فضلك ادخل موعد صحيح';
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickedDialog(control: _dateOfPaymenControlle);
                          },
                          child: DefaultTextField(
                            enabled: false,
                            focusNode: _dateOfPaymentFocusNode,
                            textEditingController: _dateOfPaymenControlle,
                            textInputType: TextInputType.phone,
                            hint: 'المعاد السداد',
                            validetor: (v) {
                              if (v.toString().isEmpty)
                                return 'من فضلك ادخل موعد صحيح';
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                       loading? Center(
                         child: CircularProgressIndicator(),
                       ): DefaultButton(
                          text: 'اضافه',
                          function: () {
                            _add();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
  _add()async{
   if(_formKey.currentState!.validate()) {
     setState(() {
       loading=true;
     });
     await FirebaseFirestore.instance.collection('users')
         .doc(FirebaseAuth.instance.currentUser!.uid)
         .collection('checks')
         .doc()
         .set({
       'from':_fromControlle.value.text,
       'to':_toControlle.value.text ,
       'dueDate':_dueDateControlle.value.text ,
       'dateOfPayment':_dateOfPaymenControlle.value.text,
       'createdAt': Timestamp.now(),
       'money':_moneyControlle.text,
       'paid':false ,
       'rejected ':false,
     });
     setState(() {
       loading=false;
     });
     Navigator.pop(context);
   }
  }

  DateTime? picked;

  pickedDialog({control} ) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        control.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        //_timestamp=Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch,);
      });
    }
  }
}
