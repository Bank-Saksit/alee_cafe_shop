import 'package:flutter/material.dart';

class CardCafe extends StatelessWidget {
  final String pathImage;
  final String cafeName;

  CardCafe({Key key, this.pathImage, this.cafeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: 150,
        height: 170,
        child: Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                border: Border.all(color: Colors.black,),
                image: DecorationImage(
                  image: NetworkImage(pathImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8,),
            Text(
              cafeName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18
              ),
            )
          ],
        ),
      ),
    );
  }
}
