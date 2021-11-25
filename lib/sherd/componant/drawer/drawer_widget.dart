import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/inner_screens/info.dart';
import 'package:financial_dealings/inner_screens/profil_screen.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/users/users.dart';
import 'package:financial_dealings/screens/auth/login/login_screen.dart';
import 'package:financial_dealings/sherd/componant/drawer/widget/category.dart';
import 'package:financial_dealings/sherd/componant/drawer/widget/drawer_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidgetAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MyDrawerHeader(),
          CategoryListTile(
            text: 'حسابي',
            function: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            iconData: FontAwesomeIcons.user,
          ),
          CategoryListTile(
            text: 'المستخدمين',
            function: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UsersList()));
            },
            iconData: Icons.people_rounded,
          ),
          CategoryListTile(
            text: 'من نحن',
            function: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InFo(
                            pdfPath: 'assets/pdfs/3.pdf',
                            title: 'من نحن',
                          )));
            },
            iconData: FontAwesomeIcons.houseUser,
          ),
          CategoryListTile(
            text: 'المساعده و الدعم',
            function: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InFo(
                            pdfPath: 'assets/pdfs/1.pdf',
                            title: 'مساعدة و الدعم',
                          )));
            },
            iconData: FontAwesomeIcons.dharmachakra,
          ),
          Divider(height: 3, color: Colors.indigoAccent),
          CategoryListTile(
            text: 'تسجيل خروج',
            function: () async {
              await FirebaseAuth.instance.signOut();
              for (; Navigator.canPop(context);) Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return LoginScreen();
              }));
            },
            iconData: Icons.logout,
          ),
        ],
      ),
    );
  }
}
class DrawerWidgetUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MyDrawerHeader(),
          CategoryListTile(
            text: 'حسابي',
            function: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            iconData: FontAwesomeIcons.user,
          ),
          CategoryListTile(
            text: 'من نحن',
            function: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InFo(
                        pdfPath: 'assets/pdfs/3.pdf',
                        title: 'من نحن',
                      )));
            },
            iconData: FontAwesomeIcons.houseUser,
          ),
          CategoryListTile(
            text: 'المساعده و الدعم',
            function: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InFo(
                        pdfPath: 'assets/pdfs/1.pdf',
                        title: 'مساعدة و الدعم',
                      )));
            },
            iconData: FontAwesomeIcons.dharmachakra,
          ),
          Divider(height: 3, color: Colors.indigoAccent),
          CategoryListTile(
            text: 'تسجيل خروج',
            function: () async {
              await FirebaseAuth.instance.signOut();
              for (; Navigator.canPop(context);) Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                    return LoginScreen();
                  }));
            },
            iconData: Icons.logout,
          ),
        ],
      ),
    );
  }
}