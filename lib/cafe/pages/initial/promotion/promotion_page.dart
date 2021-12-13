import 'package:cafe_app/cafe/blocs/navigation/bottom_navigation_bloc.dart';
import 'package:cafe_app/widgets/side_bar.dart';
import 'package:cafe_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';

class PromotionPage extends StatefulWidget {
  final BottomNavigationBloc navigationBloc;

  const PromotionPage({Key key, @required this.navigationBloc}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PromotionPageState();
}

class PromotionPageState extends State<PromotionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("โปรโมชั่น"),
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      ),
      drawer: SideBarManual(
        bloc: widget.navigationBloc,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            _buildItemList('assets/images/promotion1.jpeg'),
            SizedBox(
              height: 10,
            ),
            _buildItemList('assets/images/promotion2.jpg'),
            SizedBox(
              height: 10,
            ),
            _buildItemList('assets/images/promotion3.jpeg'),
            SizedBox(
              height: 10,
            ),
            _buildItemList('assets/images/promotion4.jpeg'),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: TabBarNavigation(
        bloc: widget.navigationBloc,
        index: 2,
      ),
    );
  }

  _buildItemList(String pathImage) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(pathImage),
        fit: BoxFit.cover,
      )),
    );
  }
}
