import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:financial_dealings/screens/auth/forget_password/virification_code_screen.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';

class ForgetPassScreen extends StatelessWidget {

  final _phoneControlle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                SizedBox(height: size.height * .1),
                PageTitle(text: 'نسيت كلمة المرور'),
                SizedBox(height: 10),
                SizedBox(height: 20),
                DefaultTextField(
                  textEditingController: _phoneControlle,
                  textInputType: TextInputType.phone,
                  hint: 'رقم الهاتف',
                  validetor: (v) {
                    if (v.toString().isEmpty || v.toString().length != 11)
                      return 'من فضلك ادخل رقم هاتف صحيح';
                  },
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .15, vertical: 20),
                  child: DefaultButton(
                    function: () {
                      FocusScope.of(context).unfocus();
                      _forgetPass();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 15,
                          backgroundColor: Colors.white,
                          content: Text('سيتم ارسال رقم تاكيد في رساله علي هذا الرقم ',style: TextStyle(
                            color: Colors.blue,
                          ),),
                        ),
                      );
                      Methods.NavReplace(ctx: context,page: VirificationCodeScreen());
                    },
                    text: 'ارسال',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _forgetPass() {
    //print("_forgetPassControll.value.text ${_forgetPassControll.value.text}");
  }
}
