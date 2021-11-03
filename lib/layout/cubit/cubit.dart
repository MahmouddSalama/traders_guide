
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/chats/screens/chat_screen.dart';
import 'package:financial_dealings/moduls/suggestions_and_complaints/suggestions_and_complaints.dart';
import 'package:financial_dealings/moduls/users/users.dart';
import '../../moduls/blac_list/black_list.dart';
import '../../moduls/chats/screens/chats_list.dart';
import '../../moduls/checks/checks.dart';
import '../../moduls/customar_accounts/customer_accounts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsCubit extends Cubit<NewsSates> {
  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);

  int curentIndex = 0;
 bool admin=true;

  List<BottomNavigationBarItem> bottomTapOfUser = [
    BottomNavigationBarItem(
      icon: Icon(Icons.supervisor_account),
      label: 'حسابات العملاء',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on_outlined),
      label: 'الشيكات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_suggest_rounded),
      label: 'مقترحات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.block_outlined),
      label: 'القائمة السوداء',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      label: 'الدردشات',
    ),
  ];

  List<BottomNavigationBarItem> bottomTapOfAdmin = [

    BottomNavigationBarItem(
      icon: Icon(Icons.supervisor_account),
      label: 'حسابات العملاء',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on_outlined),
      label: 'الشيكات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: ' المستخدمين',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_suggest_rounded),
      label: 'مقترحات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.block_outlined),
      label: 'القائمة السوداء',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_outlined),
      label: 'الدردشات',
    ),
  ];
  List screensOfUsers = [
    CustomerAccountScreen(),
    CheckScreen(),
    SuggestionsAndComplaints(),
    BlackListScreen(),
    Chats(),
  ];
  List screensOfAdmin = [
    CustomerAccountScreen(),
    CheckScreen(),
    UsersList(),
    SuggestionsAndComplaints(),
    BlackListScreen(),
    Chats(),
  ];
  void changeScreen(int index) {
    curentIndex = index;
    emit(NewsBottomNaveStates());
  }
  void isAdmin(bool admin) {
   this. admin = admin;
    emit(AdminState());
  }
}
