import 'package:financial_dealings/screens/notifications_screen/notification_screen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTapBar extends StatelessWidget {
  final Widget body1;
  final Widget body2;
  final IconData iconData1;
  final IconData iconData2;
  final String title;
  final String lapel1;
  final String lapel2;

  const MyTapBar({
    Key? key,
    required this.body1,
    required this.body2,
    required this.iconData1,
    required this.iconData2,
    required this.title,
    required this.lapel1,
    required this.lapel2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
             if( Navigator.canPop(context))
               Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            title,
            style: GoogleFonts.almarai(color: Colors.black),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            onTap: (v) {},
            tabs: [
              Tab(
                icon: Icon(iconData1, size: 25),
                text: lapel1,
              ),
              Tab(
                icon: Icon(iconData2, size: 25),
                text: lapel2,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            body1,
            body2,
          ],
        ),
      ),
    );
  }
}