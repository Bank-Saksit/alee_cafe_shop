import 'package:cafe_app/cafe/pages/initial/initial_page.dart';
import 'package:cafe_app/cafe/pages/tutorial/tutorial_page.dart';
import 'package:cafe_app/core/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();

}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: LocalStorageService.getString("firstAppStart") == '' ? TutorialPage() : InitialPage(),//AppStart(),
      title: Text(
        'ALEE Coffee SHOP',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
      ),
      image: Image.asset('assets/images/logo_black.png'),
      backgroundColor: Colors.white,
      photoSize: 150.0,
      useLoader: false,
    );
  }
}

