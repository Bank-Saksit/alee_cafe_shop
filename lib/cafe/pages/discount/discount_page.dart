import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscountPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            // Navigate back to first route when tapped.
          },
          child : Icon(Icons.arrow_back),
        ),
        title:  Text('ส่วนลดลูกค้า'),
      ),
      body: Container(
        height: 1000,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: 
              ColorFilter.mode(Colors.black.withOpacity(0.2), 
              BlendMode.dstATop),
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          )
        ),
        width: double.infinity,
        child: Text(
          'ยังไม่เปิดระบบ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25
          ),
        ),
      ),
    );
  }
}