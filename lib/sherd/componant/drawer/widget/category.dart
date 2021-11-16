import 'package:flutter/material.dart';

class CategoryListTile extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function function;

  const CategoryListTile({
    Key? key,
   required this.text,
   required this.iconData,
   required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () =>function(),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.indigoAccent,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: Colors.indigoAccent,
        size: 25,
      ),
      leading: Icon(
        iconData,
        color: Colors.indigoAccent,
        size: 25,
      ),
    );
  }
}
