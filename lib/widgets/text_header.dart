import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  final String prefixText;
  final String suffixText;

  const TextHeader({Key key, this.prefixText, this.suffixText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              prefixText,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        suffixText == ''
            ? SizedBox()
            : Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    suffixText,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
