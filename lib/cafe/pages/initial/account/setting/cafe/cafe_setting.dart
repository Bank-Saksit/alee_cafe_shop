import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/cafe/pages/initial/account/setting/cafe/setting_detail_cafe_page.dart';
import 'package:cafe_app/core/service/data_service.dart';
import 'package:cafe_app/widgets/card_cafe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CafeSettingPage extends StatefulWidget {
  @override
  _CafeSettingPageState createState() => _CafeSettingPageState();
}

class _CafeSettingPageState extends State<CafeSettingPage> {
  Future<List<CafeInfoModel>> _listCafe;
  @override
  void initState() {
    // TODO: implement initState
    _listCafe = DatabaseService.getCafeInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("TEST SETTING");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(100, 100, 100, 1),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.plus,
                color: Colors.blue.shade200,
              ),
              onPressed: () async {
                var rount = await Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SettingDetailCafePage(settingState: "Add")));
                if (rount == "addSuccess") {
                  setState(() {
                    print("ADDDDDD");
                    loadList();
                  });
                  myDialog("การเพิ่มร้านสำเร็จ");
                }
                // do something
              },
            )
          ],
          title: Text('Setting Cafe'),
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
            child: Container(
              child: FutureBuilder<List<CafeInfoModel>>(
                future: _listCafe,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("CircularProgressIndicator");
                    return Container(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    print("HAVE DATA ");
                    return new GridView.builder(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.730,
                              crossAxisSpacing: 15),
                      shrinkWrap: true,
                      controller: new ScrollController(keepScrollOffset: false),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      padding: new EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            _popUpEditAndDelete(snapshot.data[index]);
                          },
                          child: Container(
                              width: double.infinity,
                              child: CardCafe(
                                pathImage: snapshot.data[index].cafePathImage,
                                cafeName: snapshot.data[index].cafeName,
                              )),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }

  Future<bool> loadList() async {
    setState(() {
      _listCafe = DatabaseService.getCafeInfo();
    });
    print("HAVE DATA2");
    return true;
  }

  Future<bool> deleteList() async {
    _listCafe = DatabaseService.getCafeInfo();
    print("HAVE DATA2");
    return true;
  }

  _popUpEditAndDelete(CafeInfoModel cafe) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: 250,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("ร้าน : " + cafe.cafeName,
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.green,
                    child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        var rount = await Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SettingDetailCafePage(
                                      settingState: "Edit",
                                      cafe: cafe,
                                    )));

                        if (rount == "editSuccess") {
                          loadList();
                          setState(() {
                          });
                          myDialog("การแก้ไขร้านสำเร็จ");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 100,
                        child: Text(
                          "แก้ไข",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () async{
                      Navigator.of(context).pop();
                      await DatabaseService.delectCafe(cafe);
                      setState(() {
                        loadList();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: 100,
                      child: Text(
                        "ลบ",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    color: Colors.red,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  myDialog(text) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: 150,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0x000000).withOpacity(0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "ตกลง",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
