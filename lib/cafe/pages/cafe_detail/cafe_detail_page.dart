import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/cafe/pages/cafe_detail/cafe_comment_page.dart';
import 'package:cafe_app/cafe/pages/cafe_detail/widgets/banner_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CafeDetail extends StatelessWidget {
  final CafeInfoModel cafeInfoModel;

  const CafeDetail({Key key, this.cafeInfoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            // Navigate back to first route when tapped.
          },
          child: Icon(Icons.arrow_back),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CafeCommentPage(cafe: cafeInfoModel,)));
            },
            child: Icon(FontAwesomeIcons.comments),
          ),
          SizedBox(
            width: 15.0,
          ),
        ],
        title: Text(cafeInfoModel.cafeName),
      ),
      body: Container(
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
            children: <Widget>[
              BannerCafe(
                pathImage: cafeInfoModel.cafePathImage,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding:
                    EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFormatText(mainText: cafeInfoModel.cafeDescription),
                    SizedBox(height: 20),
                    _buildFormatText(
                        header: 'ที่อยู่', mainText: cafeInfoModel.cafeAddress),
                    SizedBox(height: 20),
                    _buildFormatText(
                        header: 'เวลาเปิด-ปิด',
                        mainText: cafeInfoModel.cafeTimeDescription),
                    SizedBox(height: 20),
                    _buildFormatText(
                        header: 'เบอร์โทรติดต่อ',
                        mainText: cafeInfoModel.cafePhoneNumber),
                    SizedBox(height: 20),
                    _buildFormatText(
                        header: 'ประเภท', mainText: cafeInfoModel.cafeCategory),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildFormatText({String header = "", String mainText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        header == ""
            ? SizedBox()
            : Text(
                header + " : ",
                style: TextStyle(fontSize: 25),
              ),
        Text(
          '\t\t\t\t\t\t' + mainText,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
