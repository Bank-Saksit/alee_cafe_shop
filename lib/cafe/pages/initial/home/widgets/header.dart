import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final TrackingScrollController scrollController;

  const Header(this.scrollController);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(3.0, 3.0),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: <Widget>[
              _buildIconButton(
                  onPressed: () => print("click"),
                  icon: Icons.menu,
              ),
              SizedBox(width: 10,),
              _buildInputSearch(),
              _buildIconButton(
                onPressed: () => print("click"),
                icon: Icons.shopping_cart,
                notification: 5
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildInputSearch() {
    final sizeIcon = BoxConstraints(
      minWidth: 40,
      minHeight: 40,
    );

    final border = OutlineInputBorder(
        borderSide: const BorderSide(
            color: Colors.black,
            width: 2
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(30.0),
        )
    );

    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(3),
          hintText: "ชื่อคาเฟ่",
          enabledBorder: border,
          focusedBorder: border,
          isDense: true,
          hintStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
          prefixIcon: Icon(Icons.search),
          prefixIconConstraints: sizeIcon,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  _buildIconButton({
    VoidCallback onPressed,
    IconData icon,
    int notification = 0,
  }) {
    return IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: Colors.black,
          iconSize: 30,
        );
  }


}
