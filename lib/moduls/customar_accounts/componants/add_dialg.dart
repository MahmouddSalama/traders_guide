import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:flutter/material.dart';
class AddCustomar extends StatefulWidget {

  @override
  _AddCustomarState createState() => _AddCustomarState();
}

class _AddCustomarState extends State<AddCustomar> {
  FocusNode _nameFocusNode=FocusNode();
  FocusNode _idFocusNode=FocusNode();
  FocusNode _addressFocusNode=FocusNode();
  FocusNode _moneyFocusNode=FocusNode();
  FocusNode _dateFocusNode=FocusNode();
  FocusNode _phoneFocusNode=FocusNode();

  final _nameControlle=TextEditingController();
  final _idControlle=TextEditingController();
  final _addressControlle=TextEditingController();
  final _moneyControlle=TextEditingController();
  final _dateControlle=TextEditingController();
  final _phoneControlle=TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      
      height: size.height*.55,
            child: Stack(
              children: [
                BackgroundAnimationImage(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DefaultTextField(
                          focusNode: _nameFocusNode,
                          nextFocusNode: _idFocusNode,
                          textEditingController: _nameControlle,
                          textInputType: TextInputType.name,
                          hint: 'الاسم',
                          validetor: (v) {
                            if (v.toString().isEmpty )
                              return 'من فضلك ادخل اسم صحيح';
                          },
                        ),
                        DefaultTextField(
                          focusNode: _idFocusNode,
                          nextFocusNode: _phoneFocusNode,
                          textEditingController: _idControlle,
                          textInputType: TextInputType.number,
                          hint: 'رقم القومي',
                          validetor: (v) {
                            if (v.toString().isEmpty || v.toString().length!=11)
                              return 'من فضلك ادخل رقم صحيح';
                          },
                        ),
                        DefaultTextField(
                          focusNode: _phoneFocusNode,
                          nextFocusNode: _addressFocusNode,
                          textEditingController: _phoneControlle,
                          textInputType: TextInputType.phone,
                          hint: 'رقم الهاتف',
                          validetor: (v) {
                            if (v.toString().isEmpty||v.toString().length!=11 )
                              return 'من فضلك ادخل رقم صحيح';
                          },
                        ),
                        DefaultTextField(
                          focusNode: _addressFocusNode,
                          nextFocusNode: _moneyFocusNode,
                          textEditingController: _addressControlle,
                          textInputType: TextInputType.text,
                          hint: 'عنوان',
                          validetor: (v) {
                            if (v.toString().isEmpty )
                              return 'من فضلك ادخل عنوان صحيح';
                          },
                        ),
                        DefaultTextField(
                          focusNode: _moneyFocusNode,
                          nextFocusNode: _dateFocusNode,
                          textEditingController: _moneyControlle,
                          textInputType: TextInputType.number,
                          hint: 'القيمة المالية',
                          validetor: (v) {
                            if (v.toString().isEmpty )
                              return 'من فضلك ادخل رقم صحيح';
                          },
                        ),
                        GestureDetector(
                          onTap: (){pickedDialog();},
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
                        DefaultButton(text: 'اضافه',function: (){},)
                      ],
                    ),
                  ),
                ),
              ],
            )

    );
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
