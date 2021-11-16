import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/inner_screens/profil_screen.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/users/users.dart';
import 'package:financial_dealings/sherd/componant/drawer/widget/category.dart';
import 'package:financial_dealings/sherd/componant/drawer/widget/drawer_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsSates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NewsCubit.get(context);
          _isAdmin(context);
          return Drawer(
            child: ListView(
              children: [
                MyDrawerHeader(),
                CategoryListTile(
                  text: 'حسابي',
                  function: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  iconData: FontAwesomeIcons.user,
                ),
                if (NewsCubit.get(context).admin)
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
                  function: () {},
                  iconData: FontAwesomeIcons.houseUser,
                ),
                CategoryListTile(
                  text: 'المساعده و الدعم',
                  function: () {},
                  iconData: FontAwesomeIcons.dharmachakra,
                ),
                Divider(height: 3, color: Colors.indigoAccent),
                CategoryListTile(
                  text: 'تسجيل خروج',
                  function: ()async {
                   await FirebaseAuth.instance.signOut();
                  },
                  iconData: Icons.logout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _isAdmin(ctx) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    NewsCubit.get(ctx).isAdmin(user['admin']);
  }
}
