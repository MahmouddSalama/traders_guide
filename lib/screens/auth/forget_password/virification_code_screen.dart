import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:financial_dealings/screens/auth/forget_password/new_pass.dart';
import 'package:financial_dealings/sherd/componant/animaiton_background.dart';
import 'package:financial_dealings/sherd/componant/default_button.dart';
import 'package:financial_dealings/sherd/componant/virification_textfield.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';

class VirificationCodeScreen extends StatelessWidget {
  final _virifyControll = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        BackgroundAnimationImage(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              SizedBox(height: size.height * .1),
              PageTitle(text: 'الرقم التاكيدي'),
              SizedBox(height: 50),
              VirificationTextField(textEditingController: _virifyControll),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .15, vertical: 20),
                child: DefaultButton(
                  function: () {
                    FocusScope.of(context).unfocus();
                    Methods.NavReplace(page: NewPassword(),ctx: context);
                  },
                  text: 'تاكيد',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
