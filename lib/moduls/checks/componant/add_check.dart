import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:flutter/material.dart';





class AddCheck extends StatefulWidget {
  @override
  _AddCheckState createState() => _AddCheckState();
}

class _AddCheckState extends State<AddCheck> {
  FocusNode _fromFocusNode = FocusNode();
  FocusNode _toFocusNode = FocusNode();
  FocusNode _dateOfPaymentFocusNode = FocusNode();
  FocusNode _dueDateFocusNode = FocusNode();

  final _fromControlle = TextEditingController();
  final _toControlle = TextEditingController();
  final _dateOfPaymenControlle = TextEditingController();
  final _dueDateControlle = TextEditingController();

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
                        nextFocusNode: _dueDateFocusNode,
                        textEditingController: _toControlle,
                        textInputType: TextInputType.phone,
                        hint: 'الشيك إلي',
                        validetor: (v) {
                          if (v.toString().isEmpty)
                            return 'من فضلك ادخل الاسم صحيح';
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
                          hint: 'المعاد',
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
                          hint: 'المعاد',
                          validetor: (v) {
                            if (v.toString().isEmpty)
                              return 'من فضلك ادخل موعد صحيح';
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      DefaultButton(
                        text: 'اضافه',
                        function: () {},
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  DateTime? picked;

  pickedDialog({control} ) async {
    picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    if (picked != null) {
      setState(() {
        control.text = '${picked!.year}-${picked!.month}-${picked!.day}';
        //_timestamp=Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch,);
      });
    }
  }
}
