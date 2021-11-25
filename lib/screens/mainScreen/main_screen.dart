import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_dealings/layout/cubit/cubit.dart';
import 'package:financial_dealings/layout/cubit/stats.dart';
import 'package:financial_dealings/moduls/blac_list/black_list.dart';
import 'package:financial_dealings/moduls/blck_list_admin/admin_blak_list.dart';
import 'package:financial_dealings/moduls/chats/screens/chat_screen.dart';
import 'package:financial_dealings/moduls/checks/checks.dart';
import 'package:financial_dealings/moduls/customar_accounts/customer_accounts.dart';
import 'package:financial_dealings/moduls/suggestions_and_complaints/screens/user_suggest.dart';
import '../../moduls/suggestions_and_complaints/screens/suggestions_and_complaints.dart';
import 'package:financial_dealings/sherd/componant/main_wiget/main_widgei.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context)=>NewsCubit(),
      child: BlocConsumer<NewsCubit,NewsSates>(
        listener: (context,s){},
        builder:(context,s){
          var cubit = NewsCubit.get(context);
          _isAdmin(context);
          return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      MainWidget(
                        text: 'حساب العملاء',
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerAccountScreen()));
                        },
                        imagUrl:
                            'https://www.tebalink.com/wp-content/uploads/2017/02/accounting_1024x683.jpg',
                      ),
                      MainWidget(
                        text: 'الشيكات',
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckScreen()));
                        },
                        imagUrl:
                            'https://ibelieveinsci.com/wp-content/uploads/cashiers-check-vs-money-order-whats-the-difference.jpg',
                      ),
                      MainWidget(
                        text: 'القائمة السوداء',
                        function: () {
                          if(cubit.admin)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminBlackLists()));
                          else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlackListScreen()));
                          }
                        },
                        imagUrl:
                            'https://boyemen.com/user_images/news/09-10-15-651559948.jpg',
                      ),
                      MainWidget(
                        text: 'الدردشات',
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Chats()));
                        },
                        imagUrl:
                            'https://1.bp.blogspot.com/--Bp9VRCVee4/XcxevdcQQkI/AAAAAAAAJuY/ousklgKLBicFRjdw6we1Z0zHnq9zk2cLwCLcBGAsYHQ/s1600/%25D9%2585%25D8%25AD%25D8%25A7%25D8%25AF%25D8%25AB%25D8%25A9%2B%25D8%25A8%25D8%25A7%25D9%2584%25D9%2584%25D8%25BA%25D8%25A9%2B%25D8%25A7%25D9%2584%25D8%25A7%25D9%2586%25D8%25AC%25D9%2584%25D9%258A%25D8%25B2%25D9%258A%25D8%25A9%2B%25D9%2581%25D9%2589%2B%25D8%25A7%25D9%2584%25D8%25B9%25D9%258A%25D8%25A7%25D8%25AF%25D8%25A9%2BIn%2Bthe%2Bclinic.PNG',
                      ),
                      MainWidget(
                        text: 'المقترحات و الشكاوي',
                        function: () {
                          if(cubit.admin)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SuggestionsAndComplaints()));
                          else
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserSuggest()));
                        },
                        imagUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRf9nhGKiQdiLt-aVuP0z0avBhj7tERVw1cWw&usqp=CAU',
                      ),
                    ],
                  ),
                ),
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
