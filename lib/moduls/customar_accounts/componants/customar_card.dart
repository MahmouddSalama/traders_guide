import 'package:financial_dealings/moduls/customar_accounts/screens/customar_information_screeen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  final  index;

  const CustomerCard({Key? key,required this.index}) : super(key: key);
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
                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60'),
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
            onLongPress: () {},
            onTap: () {
              Methods.Navplace(ctx: context,page: CustomerInformation());
            },
          ),
          Divider(thickness: 2)
        ],
      ),
    );
  }
}
