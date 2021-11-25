


import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/layout/main_layout.dart';
import 'package:financial_dealings/moduls/blck_list_admin/admin_blak_list.dart';
import 'package:financial_dealings/moduls/chats/screens/chat_screen.dart';
import 'package:financial_dealings/moduls/suggestions_and_complaints/screens/user_suggest.dart';
import '../../moduls/suggestions_and_complaints/screens/suggestions_and_complaints.dart';
import 'package:financial_dealings/moduls/users/users.dart';
import 'package:financial_dealings/screens/mainScreen/main_screen.dart';
import '../../moduls/blac_list/black_list.dart';
import '../../moduls/checks/checks.dart';
import '../../moduls/customar_accounts/customer_accounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsCubit extends Cubit<NewsSates> {
  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);

  int curentIndex = 0;
 bool admin=true;
 bool bloked=false;
  List<BottomNavigationBarItem> bottomTap = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'الرائسيه',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_suggest_rounded),
      label: 'مقترحات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      label: 'الدردشات',
    ),
  ];
  List screensUser = [
    MainScreen(),
    UserSuggest(),
    Chats(),
  ];
  List screenAdmin = [
    MainScreen(),
    SuggestionsAndComplaints(),
    Chats(),
  ];
  List titls=[
    'دليل التجار',
    'المقترحات و الشكاوي',
    'الدردشات الجماعية'
  ];
  void changeScreen(int index) {
    curentIndex = index;
    emit(NewsBottomNaveStates());
  }
  void isAdmin(bool admin) {
   this. admin = admin;
    emit(AdminState());
  }
  void isBlocked( bool bloked){
    this.bloked=bloked;
    emit(UserBlocked());
  }

}
