import 'package:cafe_app/cafe/blocs/home_search/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarSearch extends StatelessWidget with PreferredSizeWidget {
  final BuildContext context;

  AppBarSearch({Key key, @required this.context}) : super(key: key);

  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      title: _buildSearchField(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: InkWell(
            onTap: () {
              _launchURL();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  image: DecorationImage(
                    image: AssetImage("assets/images/chatbot.jpg"),
                  )),
            ),
          ),
        )
      ],
    );
  }

  _launchURL() async {
    const url = 'https://line.me/R/ti/p/%40762nfkgr';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildSearchField() {
    updateSearchQuery("");
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchQueryController,
        decoration: InputDecoration(
          hintText: "ค้นหาคาเฟ่",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.search),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery(query),
      ),
    );
  }

  void updateSearchQuery(String newQuery) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    bloc.add(SearchCafe(text: newQuery));
  }
}
