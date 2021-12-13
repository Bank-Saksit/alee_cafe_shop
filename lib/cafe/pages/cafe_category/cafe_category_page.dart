import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/cafe/pages/cafe_detail/cafe_detail_page.dart';
import 'package:cafe_app/cafe/viewmodels/cafe_info_viewmodel.dart';
import 'package:cafe_app/core/service/data_service.dart';
import 'package:cafe_app/widgets/card_cafe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CafeCategoryPage extends StatefulWidget {
  final String type;

  const CafeCategoryPage({Key key, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CafeCategoryPageState();
}

class CafeCategoryPageState extends State<CafeCategoryPage> {

  List<CafeInfoModel> _cafe = DatabaseService.listCafe;

  @override
  void initState() {
    List<CafeInfoModel> newListData = List<CafeInfoModel>();
    _cafe.forEach((item) {
      if(item.cafeCategory.contains(widget.type)) {
        newListData.add(item);
      }
    });
    _cafe = newListData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(100, 100, 100, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            // Navigate back to first route when tapped.
          },
          child : Icon(Icons.arrow_back),
        ),
        title:  Text(widget.type),
      ),
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
              child : Column(
                  children: <Widget>[
                    _buildCafeList(),
                  ],
                ),
        ),
      ),
    );
  }

  _buildCafeList() {
    return Container(
      height: 900,
      child: new GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.730,
            crossAxisSpacing: 15
        ),
        shrinkWrap: true,
        controller: new ScrollController(keepScrollOffset: false),
        scrollDirection: Axis.vertical,
        itemCount: _cafe.length,
        padding: new EdgeInsets.only(
          left : 8.0,
          right: 8.0,
          top: 10.0,
          bottom: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              return Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => CafeDetail(
                    cafeInfoModel : _cafe[index]
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              child: CardCafe(
                pathImage: _cafe[index].cafePathImage,
                cafeName: _cafe[index].cafeName,
              )
            ),
          );
        },
      ),
    );
  }
}