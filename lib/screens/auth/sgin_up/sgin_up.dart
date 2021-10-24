import 'package:financial_dealings/screens/auth/login/login_screen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';

import '../../../sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/screens/auth/componant/forms/regester_form.dart';
import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obsecure = true;
  final _formKey = GlobalKey<FormState>();

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
                SizedBox(height: size.height * .1),
                PageTitle(text: 'انشاء حساب'),
                SizedBox(height: 9),
                TogelText(
                  qustion: 'لدي حساب بالفعل',
                  operation: 'دخول',
                  function: (){
                    Methods.NavReplace(ctx: context,page: LoginScreen());
                  },
                ),
                SizedBox(height: 15),
                RegisterForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }


}