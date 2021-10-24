import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _passControlle = TextEditingController();
  final _rePassControlle = TextEditingController();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _rePassFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool obsecure = true;
  void dispose() {
    // TODO: implement dispose
    _passControlle.dispose();
    _rePassControlle.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            BackgroundAnimationImage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: size.height * .1),
                    PageTitle(text: 'كلمه مرور جديده'),
                    SizedBox(height: 50),
                    DefaultTextField(
                      textInputType: TextInputType.visiblePassword,
                      focusNode: _passFocusNode,
                      nextFocusNode: _rePassFocusNode,
                      textEditingController: _passControlle,
                      hint: 'كلمة مرور الجديدة',
                      validetor: (v) {
                        if (v.toString().isEmpty || v.toString().length < 7)
                          return 'يجب علي كلمة المرور ان لا تقل عن 7 احرف';
                      },
                      isPass: obsecure,
                      sufix: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        icon: Icon(
                          obsecure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DefaultTextField(
                      textInputType: TextInputType.visiblePassword,
                      focusNode: _rePassFocusNode,
                      textEditingController: _rePassControlle,
                      hint: 'تأكيد كلمة المرور',
                      validetor: (v) {
                        if ((v.toString().isEmpty || v.toString().length < 7) &&
                            _passControlle.text != _rePassControlle.text)
                          return 'ليست تأكيد لكلمة المرور';
                      },
                      isPass: obsecure,
                      sufix: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        icon: Icon(
                          obsecure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * .15, vertical: 20),
                      child: DefaultButton(
                        function: () {
                          FocusScope.of(context).unfocus();
                        },
                        text: 'تاكيد',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
