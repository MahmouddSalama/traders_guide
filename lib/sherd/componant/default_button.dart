import 'package:financial_dealings/screens/auth/componant/texts.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Function function;
  final String text;
  final IconData? iconData;

  const DefaultButton({
    Key? key,
    required this.function,
    required this.text,
     this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => function(),
      color: Colors.blue.shade500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PageTitle(text: text),
            SizedBox(
              width: 5,
            ),
            if(iconData!=null)
            Icon(
              iconData,
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
