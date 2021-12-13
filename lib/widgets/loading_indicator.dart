import 'package:flutter/material.dart';

class LoadingIndigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading..."),
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      ),
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
