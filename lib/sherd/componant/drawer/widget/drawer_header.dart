import 'package:flutter/material.dart';


class MyDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        child: Column(
          children: [
            Flexible(
              child: Image.asset('assets/images/pngwing.com.png')
            ),
            SizedBox(height: 10),
            Flexible(
              child: Text(
                'دليل التجار',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
