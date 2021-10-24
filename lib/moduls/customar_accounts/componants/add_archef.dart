import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:flutter/material.dart';

class AddArchef extends StatefulWidget {

  @override
  _AddArchefState createState() => _AddArchefState();
}

class _AddArchefState extends State<AddArchef> {
  final _moneyControlle=TextEditingController();

  final _dateControlle=TextEditingController();

  final _typeControlle=TextEditingController();

  FocusNode _moneyFocusNode=FocusNode();

  FocusNode _dateFocusNode=FocusNode();

  FocusNode _typeFocusNode=FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
        height: size.height*.40,
        child: Stack(
          children: [
            BackgroundAnimationImage(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Column(
                children: [
                  DefaultTextField(
                    focusNode: _moneyFocusNode,
                    nextFocusNode: _typeFocusNode,
                    textEditingController: _moneyControlle,
                    textInputType: TextInputType.number,
                    hint: 'المبلغ',
                    validetor: (v) {
                      if (v.toString().isEmpty )
                        return 'من فضلك ادخل عنوان صحيح';
                    },
                  ),
                  DefaultTextField(
                    focusNode: _typeFocusNode,
                    nextFocusNode: _dateFocusNode,
                    textEditingController: _typeControlle,
                    textInputType: TextInputType.text,
                    hint: 'النوع',
                    validetor: (v) {
                      if (v.toString().isEmpty )
                        return 'من فضلك ادخل نوع صحيح';
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
                  SizedBox(height: 30),
                  DefaultButton(text: 'اضافه',function: (){},)
                ],
              ),
            )
          ],
        ),
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
