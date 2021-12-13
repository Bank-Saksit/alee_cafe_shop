import 'dart:io';

import 'package:cafe_app/cafe/blocs/authentication/bloc.dart';
import 'package:cafe_app/cafe/blocs/navigation/bottom_navigation_bloc.dart';
import 'package:cafe_app/cafe/pages/initial/account/setting/cafe/cafe_setting.dart';
import 'package:cafe_app/core/service/data_service.dart';
import 'package:cafe_app/widgets/loading_popup.dart';
import 'package:cafe_app/widgets/side_bar.dart';
import 'package:cafe_app/widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatefulWidget {
  final BottomNavigationBloc navigationBloc;
  final AuthenticationBloc authenBloc;
  final String urlProfile;
  AccountPage({
    Key key,
    @required this.navigationBloc,
    @required this.authenBloc,
    @required this.urlProfile,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  TextEditingController usernameController = TextEditingController();
  File file;
  User user = FirebaseAuth.instance.currentUser;
  String url = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("บัญชี"),
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      ),
      drawer: SideBarManual(
        bloc: widget.navigationBloc,
      ),
      bottomNavigationBar: TabBarNavigation(
        bloc: widget.navigationBloc,
        index: 3,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0),
        height: 1000,
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  _imageProfile(),
                  _buttonChangeProfile(),
                ],
              ),
              SizedBox(height: 10.0),
              _userInfo(),
              SizedBox(height: 30.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                alignment: Alignment.topLeft,
                child: Text(
                  'โปรไฟล์',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              SizedBox(height: 10.0),
              _settingUsername(),
              SizedBox(height: 10.0),
              DatabaseService.userRole == "admin"
                  ? Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'ตั้งค่า',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    )
                  : SizedBox(),
              DatabaseService.userRole == "admin"
                  ? SizedBox(height: 10.0)
                  : SizedBox(),
              DatabaseService.userRole == "admin"
                  ? _settingListTile()
                  : SizedBox(),
              SizedBox(height: 10.0),
              _logOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageProfile() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(300),
        border: Border.all(
          color: Colors.black,
        ),
        image: DecorationImage(
          image:
              file == null ? NetworkImage(widget.urlProfile) : FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buttonChangeProfile() {
    return InkWell(
      onTap: () {
        chooseFile();
      },
      child: Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          borderRadius: BorderRadius.circular(300),
        ),
        child: Opacity(
            opacity: 0.5,
            child: Icon(
              FontAwesomeIcons.plus,
              color: Colors.green,
            )),
      ),
    );
  }

  Widget _userInfo() {
    return Text(user.displayName);
  }

  // Widget _addButton() {
  //   return InkWell(
  //     onTap: () {
  //       final dbRef = FirebaseDatabase.instance.reference().child("cafe");
      //   CafeInfoViewmodel cafeInfoViewmodel = CafeInfoViewmodel();
      //   for(CafeInfoModel item  in cafeInfoViewmodel.getCafeInfo()){
      //     dbRef.push().set({
      //       "cafeName": item.cafeName,
      //       "cafeDescription": item.cafeDescription,
      //       "cafeAddress": item.cafeAddress,
      //       "cafeTimeDescription": item.cafeTimeDescription,
      //       "cafePhoneNumber": item.cafePhoneNumber,
      //       "cafePathImage": item.cafePathImage,
      //       "cafeCategory": item.cafeCategory,
      //     });
      //   }
  //     dbRef.once().then((DataSnapshot snapshot) {
  //     print('Data : ${snapshot.value}');
  // });
  //     },
  //     child: Container(
  //       width: MediaQuery.of(context).size.width,
  //       margin: EdgeInsets.all(15.0),
  //       padding: EdgeInsets.symmetric(vertical: 15),
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(5)),
  //           boxShadow: <BoxShadow>[
  //             BoxShadow(
  //                 color: Colors.grey.shade200,
  //                 offset: Offset(2, 4),
  //                 blurRadius: 5,
  //                 spreadRadius: 2)
  //           ],
  //           gradient: LinearGradient(
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //               colors: [
  //                 Color.fromRGBO(100, 100, 100, 1),
  //                 Color.fromRGBO(50, 50, 50, 1)
  //               ])),
  //       child: Text(
  //         'AddData',
  //         style: TextStyle(fontSize: 20, color: Colors.white),
  //       ),
  //     ),
  //   );
  // }

  Widget _logOutButton() {
    return InkWell(
      onTap: () {
        signOut();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(100, 100, 100, 1),
                  Color.fromRGBO(50, 50, 50, 1)
                ])),
        child: Text(
          'ออกจากระบบ',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _settingUsername() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        child: Column(children: [
          ListTile(
              leading: Icon(FontAwesomeIcons.idCard),
              title: Text('ชื่อแสดง'),
              trailing: Text(user.displayName),
              onTap: () {
                usernameController.text = user.displayName;
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  barrierColor: Colors.black45,
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (BuildContext buildContext, Animation animation,
                      Animation secondaryAnimation) {
                    return Material(
                      type: MaterialType.transparency,
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 180,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(children: [
                                Text(
                                  "ชื่อแสดง",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 10.0),
                                TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true))
                              ]),
                              SizedBox(height: 10),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "ยกเลิก",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 10.0),
                                    RaisedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        LoadingPopup.show("Loading..",context);
                                        await user.updateProfile(displayName: usernameController.text.trim());
                                          user = FirebaseAuth.instance.currentUser;
                                        setState(() {
                                        });
                                        Navigator.of(context).pop();
                                        
                                      },
                                      child: Text(
                                        "แก้ไข",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.green,
                                    )
                                  ])
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              })
        ]));
  }

  Widget _settingListTile() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(FontAwesomeIcons.coffee),
            title: Text('ตั้งค่าร้านคาเฟ่'),
            onTap: () {
              var rount = new MaterialPageRoute(
                  builder: (BuildContext context) => CafeSettingPage());
              Navigator.of(context).push(rount);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBorder() {
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

  void signOut() {
    widget.authenBloc.add(LoggedOut());
  }

  Future<void> chooseFile() async {
    File pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxHeight: 300,
      maxWidth: 300,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'ปรับแต่งรูปภาพ',
          toolbarColor: Color.fromRGBO(100, 100, 100, 1),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'ปรับแต่งรูปภาพ',
      ),
    );
    if (croppedFile != null) {
      LoadingPopup.show("Upload Prolfile..", context);
      widget.authenBloc.add(ChangeProfile(image: croppedFile));
      Navigator.pop(context);
    }
  }
}
