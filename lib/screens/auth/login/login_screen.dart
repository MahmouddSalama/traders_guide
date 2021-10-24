import 'package:financial_dealings/screens/auth/sgin_up/sgin_up.dart';
import 'package:financial_dealings/sherd/methods/method.dart';

import '../../../sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/screens/auth/componant/forms/login_form.dart';
import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundAnimationImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                SizedBox(height: size.height*.1 ,),
                PageTitle(text: 'تسجيل دخول'),
                SizedBox(height: 9),
                TogelText(
                  function: () {
                    Methods.NavReplace(page: SignUpScreen(),ctx: context);
                  },
                  qustion: 'ليس لدي لدي حساب',
                  operation: 'انشاء حساب',
                ),
                SizedBox(height: 15),
                LoginForm()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
