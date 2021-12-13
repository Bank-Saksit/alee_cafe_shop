import 'package:cafe_app/cafe/pages/splash_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe App',
      debugShowCheckedModeBanner : false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color.fromRGBO(229, 233, 236, 1),
        fontFamily: 'Abril Fatface',
      ),
      home: SplashPage(),
    );
  }
}
