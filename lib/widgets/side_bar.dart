import 'package:cafe_app/cafe/blocs/navigation/bloc.dart';
import 'package:cafe_app/cafe/pages/cafe_category/cafe_category_page.dart';
import 'package:cafe_app/cafe/pages/discount/discount_page.dart';
import 'package:cafe_app/core/service/data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideBarManual extends StatelessWidget {
  final BottomNavigationBloc bloc;

  const SideBarManual({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(300),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          image: DecorationImage(
                            image: DatabaseService.profileImagePath == "" ? AssetImage('assets/images/logo_black.png') : NetworkImage(DatabaseService.profileImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      user != null ? Text(user.displayName) : Text('ALEE Coffee Shop'),
                    ],
                  ),
                ),
              ),
              _buildBorder(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('หน้าแรก'),
                onTap: () {
                  Navigator.of(context).pop();
                  bloc.add(PageSelected(indexPage: 0));
                },
              ),
              _buildBorder(),
              ListTile(
                leading: Icon(Icons.local_cafe),
                title: Text('ประเภทคาเฟ่'),
              ),
              _buildBorder(),
              ListTile(
                leading: Icon(Icons.remove),
                title: Text('คาเฟ่นั่งทำงาน'),
                onTap: () {
                  Navigator.of(context).pop();
                  var rount = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CafeCategoryPage(type: 'คาเฟ่นั่งทำงาน'));
                  Navigator.of(context).push(rount);
                },
              ),
              _buildBorder(),
              ListTile(
                leading: Icon(Icons.remove),
                title: Text('คาเฟ่ดอกไม้'),
                onTap: () {
                  Navigator.of(context).pop();
                  var rount = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CafeCategoryPage(type: 'คาเฟ่ดอกไม้'));
                  Navigator.of(context).push(rount);
                },
              ),
              _buildBorder(),
              ListTile(
                leading: Icon(Icons.remove),
                title: Text('คาเฟ่วินเทจ'),
                onTap: () {
                  Navigator.of(context).pop();
                  var rount = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CafeCategoryPage(type: 'คาเฟ่วินเทจ'));
                  Navigator.of(context).push(rount);
                },
              ),
              _buildBorder(),
              ListTile(
                leading: Icon(Icons.remove),
                title: Text('คาเฟ่มินิมอล'),
                onTap: () {
                  Navigator.of(context).pop();
                  var rount = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          CafeCategoryPage(type: 'คาเฟ่มินิมอล'));
                  Navigator.of(context).push(rount);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _buildBorder() {
    return Container(
        decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1.0,
          color: Colors.black,
        ),
      ),
    ));
  }
}
