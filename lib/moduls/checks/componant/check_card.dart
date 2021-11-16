import 'package:financial_dealings/moduls/checks/screens/check_information.dart';
import 'package:financial_dealings/moduls/customar_accounts/screens/customar_information_screeen.dart';
import 'package:financial_dealings/sherd/methods/method.dart';
import 'package:flutter/material.dart';

class CheckCard extends StatelessWidget {
  final id;
  final name;
  final date;
  final index;
  final Function delete;
  final ColorsList = List.generate(32, (index) => Colors.primaries[index % 16]);

  CheckCard({
    required this.date,
    Key? key,
    required this.index,
    required this.delete,
    required this.id,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          ListTile(
            title: Text(name),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ColorsList[index],
            ),
            subtitle: Text(date),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: ColorsList[index],
              ),
              onPressed: () => delete(),
            ),
            onLongPress: () {},
            onTap: () {
              Methods.Navplace(
                page: CheckInformation(
                  color: ColorsList[index],
                  id: id,
                ),
                ctx: context,
              );
            },
          ),
          Divider(thickness: 2)
        ],
      ),
    );
  }
}
