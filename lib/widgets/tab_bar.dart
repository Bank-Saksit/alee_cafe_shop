import 'package:cafe_app/cafe/blocs/navigation/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TabBarNavigation extends StatefulWidget {
  final int index;

  final BottomNavigationBloc bloc;

  const TabBarNavigation({Key key, @required this.index, @required this.bloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TabBarNavigationState();
}

class TabBarNavigationState extends State<TabBarNavigation> {
  List<Widget> originalList;
  Map<int, bool> originalDic;
  List<Widget> listScreens;
  List<int> listScreensIndex;

  int pageSelected;
  @override
  void initState() {
    pageSelected = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listItems = [
      BottomAppBarItem(iconData: Icons.home, text: 'หน้าแรก', text2: "null"),
      BottomAppBarItem(
          iconData: FontAwesomeIcons.facebook,
          text: 'facebook ',
          text2: "fanpage"),
      BottomAppBarItem(
          iconData: FontAwesomeIcons.productHunt,
          text: 'โปรโมชั่น',
          text2: "กิจกรรม"),
      BottomAppBarItem(
          iconData: Icons.supervised_user_circle, text: 'บัญชี', text2: "null"),
    ];

    var items = List.generate(listItems.length, (int index) {
      return _buildTabItem(
        item: listItems[index],
        index: index,
        onPressed: _selectedTab,
        bloc: widget.bloc,
      );
    });

    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      cubit: widget.bloc,
      builder: (context, state) {
        return BottomAppBar(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.2,
                blurRadius: 3,
                offset: Offset(0, -2),
              )
            ]),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            ),
          ),
        );
      },
    );
  }

  void _selectedTab(int index) {
    if (originalDic[index] == false) {
      listScreensIndex.add(index);
      originalDic[index] = true;
      listScreensIndex.sort();
      listScreens = listScreensIndex.map((index) {
        return originalList[index];
      }).toList();
    }
  }

  Widget _buildTabItem(
      {BottomAppBarItem item,
      int index,
      void onPressed,
      BottomNavigationBloc bloc}) {
    return Expanded(
      child: SizedBox(
        height: 70,
        child: Material(
          color: Color.fromRGBO(196, 196, 196, 1),
          child: InkWell(
            onTap: () {
              if (index == 1) {
                _launchURL();
              } else {
                print("SELECTED " + index.toString());
                bloc.add(PageSelected(indexPage: index));

                setState(() {
                  pageSelected = index;
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  item.iconData,
                  color: index == widget.index
                      ? Colors.black
                      : Color.fromRGBO(100, 100, 100, 1),
                  size: 24,
                ),
                Text(
                  item.text,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: index == widget.index
                        ? Colors.black
                        : Color.fromRGBO(100, 100, 100, 1),
                  ),
                ),
                item.text2 == "null"
                    ? SizedBox()
                    : Text(
                        item.text2,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: index == widget.index
                              ? Colors.black
                              : Color.fromRGBO(100, 100, 100, 1),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://www.facebook.com/Coffee-SHOP-AREE-104208781409086';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class BottomAppBarItem {
  BottomAppBarItem({this.iconData, this.text, this.text2});
  IconData iconData;
  String text;
  String text2;
}
