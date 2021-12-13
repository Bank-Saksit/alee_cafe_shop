import 'package:cafe_app/cafe/blocs/home_search/bloc.dart';
import 'package:cafe_app/cafe/blocs/navigation/bottom_navigation_bloc.dart';
import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/cafe/pages/cafe_detail/cafe_detail_page.dart';
import 'package:cafe_app/cafe/pages/initial/home/widgets/app_bar.dart';
import 'package:cafe_app/cafe/pages/initial/home/widgets/banner_slider.dart';
import 'package:cafe_app/widgets/card_cafe.dart';
import 'package:cafe_app/widgets/side_bar.dart';
import 'package:cafe_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final BottomNavigationBloc navigationBloc;
  final _scrollController = TrackingScrollController();
  List<CafeInfoModel> listCafe;

  HomePage({Key key, @required this.navigationBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context)..add(InitialHome());
    print("TEST HOME");
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBarManual(
        bloc: navigationBloc,
      ),
      appBar: AppBarSearch(
        context: context,
      ),
      bottomNavigationBar: TabBarNavigation(
        bloc: navigationBloc,
        index: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        width: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              BannerSlider(),
              BlocProvider(
                create: (context) => homeBloc,
                child: BlocBuilder<HomeBloc, HomeState>(
                  cubit: homeBloc,
                  builder: (context, state) {
                    if (state is CafeLoading) {
                      return Container(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is CafeLoaded) {
                      listCafe = state.listCafe;
                      print("testsetestestests : " + listCafe.length.toString());
                      return _buildCafeList();
                    }
                    return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
    /*return Scaffold(
      backgroundColor: Colors.white,
      drawer: SideBarManual(),
      appBar: AppBarSearch(),
      body: Container(
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
        child: SingleChildScrollView(
              controller: _scrollController,
              child : Column(
                  children: <Widget>[
                    BannerSlider(),
                    _buildCafeList(),
                  ],
                ),
        ),
      ),
          //Header(_scrollController),
      bottomNavigationBar: TabBarNavigation(),
    );*/
  }

  _buildCafeList() {
    return Container(
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.730, crossAxisSpacing: 15),
        shrinkWrap: true,
        controller: new ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        itemCount: listCafe.length,
        padding: new EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 10.0,
          bottom: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              return Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CafeDetail(cafeInfoModel: listCafe[index]),
                ),
              );
            },
            child: Container(
                width: double.infinity,
                child: CardCafe(
                  pathImage: listCafe[index].cafePathImage,
                  cafeName: listCafe[index].cafeName,
                )),
          );
        },
      ),
    );
  }

  /*TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";*/

  /*_appBarSearch(){
    return AppBar(
      backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      title:  _buildSearchField(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: InkWell(
              onTap: () {
                _launchURL();
              },
              child: Container(
              width: 40,
              height: 40  ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                image: DecorationImage(
                  image: AssetImage("assets/images/chatbot.jpg"),
                
                )
              ),
            ),
          ),
        )
      ],
    );
  }*/

  /*final sizeIcon = BoxConstraints(
    minWidth: 40,
    minHeight: 40,
  );

  Widget _buildSearchField() {
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

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    List<CafeInfoModel> newListData = List<CafeInfoModel>();
    if (newQuery == "") {
      newListData = CafeInfoViewmodel().getCafeInfo();
    } else {
      _cafe.forEach((item) {
        if (item.cafeName.contains(newQuery)) {
          newListData.add(item);
        }
      });
    }

    setState(() {
      _cafe = newListData;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }

  _launchURL() async {
    const url = 'https://line.me/R/ti/p/%40762nfkgr';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/
}
