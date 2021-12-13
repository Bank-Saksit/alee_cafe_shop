import 'dart:io';

import 'package:flutter/material.dart';

class BannerCafe extends StatefulWidget {
  final String pathImage;
  final File fileImage;

  const BannerCafe({Key key, this.pathImage, this.fileImage})
      : super(key: key);

  @override
  _BannerCafeState createState() => _BannerCafeState();
}

class _BannerCafeState extends State<BannerCafe> {
  
  @override
  Widget build(BuildContext context) {
    if(widget.fileImage != null) print("CHECK : " + widget.fileImage.path);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
          padding: EdgeInsets.only(top: 0),
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: widget.pathImage == "default"
                  ? AssetImage("assets/images/default.png")
                  : widget.pathImage == ""
                      ? FileImage(widget.fileImage)
                      : NetworkImage(widget.pathImage),
              fit: BoxFit.fill,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 30.0, // soften the shadow
                spreadRadius: 7.0, //extend the shadow
                offset: Offset(
                  1.0, // Move to right 10  horizontally
                  1.0, // Move to bottom 5 Vertically
                ),
              )
            ],
          ),
          child: null),
    );
  }
}
