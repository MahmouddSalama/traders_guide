import 'package:financial_dealings/moduls/customar_accounts/screens/customar_information_screeen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  final index;
  final String id;
  final String name;
  final Function delete;
  final String collision;
  final ColorsList = List.generate(32, (index) => Colors.primaries[index % 16]);
  final int rest;

  CustomerCard({
    required this.rest,
    required this.id,
    Key? key,
    required this.index,
    required this.delete,
    required this.name,
    required this.collision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text('الباقي : $rest',style: TextStyle(
                  color: rest>0?Colors.black:Colors.red,
                ),),
              ],
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ColorsList[index],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: ColorsList[index],
              ),
              onPressed: () => delete(),
            ),
            onTap: () {
              Methods.Navplace(
                ctx: context,
                page: CustomerInformation(
                  index: index,
                  color: ColorsList[index],
                  //customer: customer,
                  id: id.toString(),
                  collision: collision,
                ),
              );
            },
          ),
          Divider(thickness: 2)
        ],
      ),
    );
  }
}
