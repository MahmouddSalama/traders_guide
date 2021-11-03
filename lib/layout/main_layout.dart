import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: BlocConsumer<NewsCubit, NewsSates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          var cubit = NewsCubit.get(ctx);
          _isAdmin(ctx);
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items:cubit.admin? cubit.bottomTapOfAdmin:cubit.bottomTapOfUser,
              currentIndex: cubit.curentIndex,
              onTap: (index) {
                cubit.changeScreen(index);
              },
            ),
            body:NewsCubit.get(ctx).admin?cubit.screensOfAdmin[cubit.curentIndex] : cubit.screensOfUsers[cubit.curentIndex],
          );
        },
      ),
    );
  }
  _isAdmin(ctx )async{
    var user= await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    NewsCubit.get(ctx).isAdmin(user['admin']);
  }
}
