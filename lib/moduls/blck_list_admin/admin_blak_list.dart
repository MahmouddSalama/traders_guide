import 'package:financial_dealings/moduls/blac_list/black_list.dart';
import 'package:financial_dealings/moduls/blck_list_admin/screens/admin_blacList.dart';
import 'package:financial_dealings/sherd/componant/tap_par/may_tap_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class AdminBlackLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyTapBar(
      title: 'القائمه السوداء',
      iconData1: Icons.clear,
      iconData2: Icons.block_outlined,
      lapel1: 'القائمه السوداء',
      lapel2: 'طلبات اضافة',
      body1: BlackListScreen(),
      body2: AdminBlackList(),
    );
  }
}
