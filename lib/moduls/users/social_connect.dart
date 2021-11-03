import 'package:flutter/material.dart';

class SocialContact extends StatelessWidget {
  final Color color;
  final Function function;
  final IconData iconData;

  const SocialContact({
    Key? key,
    required this.color,
    required this.function,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: color,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () => function(),
            icon: Icon(
              iconData,
              color: color,
            ),
          )),
    );
  }
}
