import 'package:financial_dealings/moduls/checks/screens/check_information.dart';
import 'package:financial_dealings/moduls/customar_accounts/screens/customar_information_screeen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';

class CheckCard extends StatelessWidget {
  final  index;

  const CheckCard({Key? key,required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text('الاسم'),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/flagged/photo-1573740144655-bbb6e88fb18a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=435&q=80'),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,color: Colors.blue,),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,color: Colors.red,),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            onLongPress: () {
            },
            onTap: () {
              Methods.Navplace(page: CheckInformation(),ctx: context);
            },
          ),
          Divider(thickness: 2)
        ],
      ),
    );
  }
}
