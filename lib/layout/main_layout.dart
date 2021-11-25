import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/sherd/componant/drawer/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsSates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          var cubit = NewsCubit.get(ctx);
          _isAdmin(ctx);
          _isBlock(ctx);
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items:
                  cubit.bottomTap,
              currentIndex: cubit.curentIndex,
              onTap: (index) {
                cubit.changeScreen(index);
              },
            ),
            appBar: AppBar(
              title: Text(
                cubit.titls[cubit.curentIndex],
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            body:cubit.admin?cubit.screenAdmin[cubit.curentIndex]:cubit.screensUser[cubit.curentIndex],
            drawer:cubit.admin? DrawerWidgetAdmin():DrawerWidgetUser(),
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
  _isBlock(ctx) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    NewsCubit.get(ctx).isBlocked(user['bloked']);
  }
}
