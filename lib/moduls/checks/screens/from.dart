import 'package:financial_dealings/moduls/checks/componant/add_check.dart';
import 'package:financial_dealings/moduls/checks/componant/check_card.dart';
import 'package:financial_dealings/moduls/customar_accounts/componants/customar_card.dart';
import 'package:financial_dealings/screens/notifications_screen/notification_screen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class From extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الشيكات',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Methods.Navplace(page: NotificationsScreen(),ctx: context);
              },
              icon: Icon(
                Icons.notifications,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
              )),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (ctx, index) {
              return CheckCard(
                index: index,
              );
            },
            itemCount: 12,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(context: context, builder: (context) => AddCheck());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
