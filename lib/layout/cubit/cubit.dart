import 'package:bloc/bloc.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/suggestions_and_complaints/suggestions_and_complaints.dart';
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

  List<BottomNavigationBarItem> bottomTap = [

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

  List screens = [
    CustomerAccountScreen(),
    CheckScreen(),
    SuggestionsAndComplaints(),
    BlackListScreen(),
    ChatListScreen(),
  ];

  void changeScreen(int index) {
    curentIndex = index;
    emit(NewsBottomNaveStates());
  }

}
