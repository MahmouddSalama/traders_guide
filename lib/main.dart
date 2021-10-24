import 'package:financial_dealings/screens/spaalsh/spalsh_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


 main(){
   runApp(MyApp());
 }
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.blue.shade400
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: IconThemeData(
            color: Colors.black,
          )
        )
      ),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale("fa", "IR") ,
      debugShowCheckedModeBanner: false,
      home:SplashScreen() ,
    );
  }
}


