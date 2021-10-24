import 'package:financial_dealings/moduls/customar_accounts/screens/creditors.dart';
import 'package:financial_dealings/moduls/customar_accounts/screens/owe.dart';
import 'package:financial_dealings/sherd/componant/tap_par/may_tap_bar.dart';
import 'package:flutter/material.dart';

class CustomerAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyTapBar(
      title: 'حساب العملاء',
      iconData1: Icons.money,
      iconData2: Icons.money_off,
      lapel1: 'مدينون',
      lapel2: 'دائنون',
      body1: Creditors(),
      body2: Owe(),
    );
  }
}
