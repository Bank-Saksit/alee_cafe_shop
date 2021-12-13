import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        BannerSection(),
      ],
    );
  }
}

class BannerSection extends StatefulWidget {
  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final List<String> _imgList = [
    "assets/images/banner1.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner4.jpg",
    "assets/images/banner5.jpg",
    "assets/images/banner6.jpg",
  ];

  int _current;

  @override
  void initState() {
    _current = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildBanner(),
        _buildIndicator(),
      ],
    );
  }

  Container _buildBanner() {
    return Container(
      padding: EdgeInsets.only(top: 0),
      width: double.infinity,
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 1.873,
          viewportFraction: 1.0,
          autoPlay: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ),
        items: _imgList
            .map(
              (item) => Image.asset(
                item,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
            .toList(),
      ),
    );
  }

  _buildIndicator() => Positioned(
        bottom: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _imgList.map((url) {
            int index = _imgList.indexOf(url);
            return Container(
              width: 6,
              height: _current == index ? 6 : 1,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: _current == index ? BoxShape.circle : BoxShape.rectangle,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      );
}
