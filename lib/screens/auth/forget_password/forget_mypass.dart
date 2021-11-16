import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/default_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPassScreen extends StatelessWidget {

  final _emailControlle = TextEditingController();

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
                  textEditingController: _emailControlle,
                  textInputType: TextInputType.emailAddress,
                  hint: 'الاميل',
                  validetor: (v) {
                    if (v.toString().isEmpty&&!v.toString().contains('@'))
                      return 'من فضلك ادخل اميل  صحيح';
                  },
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .15, vertical: 20),
                  child: DefaultButton(
                    function: () {
                      FocusScope.of(context).unfocus();
                     _forgetPass(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 15,
                          backgroundColor: Colors.white,
                          content: Text('سوف تقم بعمل كلمه مرور جديده',style: TextStyle(
                            color: Colors.blue,
                          ),),
                        ),
                      );
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

  _forgetPass(ctx)async {
   await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailControlle.text);
   Future.delayed(Duration(seconds: 2),(){
     Navigator.pop(ctx);
   });
  }
}
