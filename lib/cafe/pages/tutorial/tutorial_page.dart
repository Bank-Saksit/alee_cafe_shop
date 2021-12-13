import 'package:cafe_app/cafe/pages/initial/initial_page.dart';
import 'package:cafe_app/core/service/local_storage_service.dart';
import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg_logo.jpg"),
          fit: BoxFit.cover,
        )),
        child: _buildButtonStart(context),
      ),
    );
  }

  _buildButtonStart(var context) {
    return Positioned(
      bottom: 50,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            onPressed: () async {
              await LocalStorageService.putString("firstAppStart", "false");
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (BuildContext context) => new InitialPage()));
            },
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              'เริ่มต้นการใช้งาน',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
          ),
        ),
      ),
    );
  }
}
