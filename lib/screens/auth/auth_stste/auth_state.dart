import 'package:financial_dealings/layout/main_layout.dart';
import 'package:financial_dealings/screens/auth/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
        if(snapshot.data==null)
          return LoginScreen();
        else if(snapshot.hasData)
          return MainLayout();
        else
          return Scaffold(
            body: Center(
              child: Text('Some error happened'),
            ),
          );
      },
    );
  }
}
