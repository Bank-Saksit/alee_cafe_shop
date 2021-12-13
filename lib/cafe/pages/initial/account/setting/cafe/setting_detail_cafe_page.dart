import 'dart:io';

import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/cafe/pages/cafe_detail/widgets/banner_slider.dart';
import 'package:cafe_app/core/service/data_service.dart';
import 'package:cafe_app/widgets/loading_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:permission_handler/permission_handler.dart';

class SettingDetailCafePage extends StatefulWidget {
  final String settingState;
  final CafeInfoModel cafe;

  const SettingDetailCafePage({Key key, @required this.settingState, this.cafe})
      : super(key: key);

  @override
  _SettingDetailCafePageState createState() =>
      _SettingDetailCafePageState(cafe: cafe);
}

class _SettingDetailCafePageState extends State<SettingDetailCafePage> {
  final CafeInfoModel cafe;
  _SettingDetailCafePageState({Key key, @required this.cafe});

  String imageText = "default";
  File fileImage;
  CafeInfoModel newCafeModel = new CafeInfoModel();
  bool changeImage = false;
  String cafeCategory;

  TextEditingController cafeNameController = TextEditingController();
  TextEditingController cafeAddressController = TextEditingController();
  TextEditingController cafeDescriptionController = TextEditingController();
  TextEditingController cafePhoneNumberController = TextEditingController();
  TextEditingController cafeTimeController = TextEditingController();

  @override
  void initState() {
    if (cafe != null) {
      var tempCafe = widget.cafe;
      cafeNameController.text = tempCafe.cafeName;
      cafeDescriptionController.text = tempCafe.cafeDescription;
      cafeAddressController.text = tempCafe.cafeAddress;
      cafePhoneNumberController.text = tempCafe.cafePhoneNumber;
      cafeTimeController.text = tempCafe.cafeTimeDescription;
      cafeCategory = tempCafe.cafeCategory;
      imageText = tempCafe.cafePathImage;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
        leading: GestureDetector(
          onTap: () {
            DatabaseService.changeData = true;
            Navigator.pop(context, true);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: widget.settingState == "Add"
            ? Text("เพิ่มร้านคาเฟ่")
            : Text("แก้ไข"),
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BannerCafe(
                    pathImage: imageText,
                    fileImage: fileImage,
                  ),
                  _buildUploadImage(),
                ],
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFormatCafeName(),
                    SizedBox(height: 10.0),
                    _buildFormatcafeDescription(),
                    SizedBox(height: 10.0),
                    _buildFormatAddress(),
                    SizedBox(height: 10.0),
                    _buildFormatPhoneNumber(),
                    SizedBox(height: 10.0),
                    _buildFormatTimeName(),
                    SizedBox(height: 10.0),
                    _buildFormatCategoryName(),
                    SizedBox(height: 10.0),
                    _confirmButton(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmButton(context) {
    return InkWell(
      onTap: () async {
        print("SEND");
        var status = await confirmData(context);
        print("CONFRIM SUCCESS");
        String dialogText;
        if (status == "success") {
          cafeNameController.text = "";
          cafeAddressController.text = "";
          cafeDescriptionController.text = "";
          cafePhoneNumberController.text = "";
          cafeTimeController.text = "";
          this.imageText = "default";
          setState(() {
            cafeCategory = null;
          });
          Navigator.pop(context,
              widget.settingState == "Add" ? "addSuccess" : "editSuccess");
        } else if (status == "invalid")
          dialogText = "กรุณาใส่ข้อมูลให้ครบถ้วน";
        else if (status == "error") dialogText = "เกิดข้อผิดพลาด";

        //myDialog(dialogText, status);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.green,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
        ),
        child: widget.settingState == "Add"
            ? Text(
                'เพิ่มข้อมูลร้านค้า',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            : Text(
                'แก้ไขข้อมูลร้านค้า',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
      ),
    );
  }

  Future<String> confirmData(context) async {
    var tempName = cafeNameController.text.trim();
    var tempAddress = cafeAddressController.text.trim();
    var tempDescription = cafeDescriptionController.text.trim();
    var tempPhoneNumber = cafePhoneNumberController.text.trim();
    var tempTimeDescription = cafeTimeController.text.trim();
    var _image = this.fileImage;

    if (tempName == "" ||
        tempAddress == "" ||
        tempDescription == "" ||
        tempPhoneNumber == "" ||
        tempTimeDescription == "" ||
        cafeCategory == "") {
      print("STOP");
      return "invalid";
    } else {
      if (_image == null && widget.settingState != "Edit") return "invalid";
      String path = "";
      if (_image != null) path = 'cafe/${Path.basename(_image.path)}';

      try {
        if (widget.settingState == "Add") {
          CafeInfoModel tempCafe = new CafeInfoModel(
            cafeName: tempName,
            cafeAddress: tempAddress,
            cafeCategory: cafeCategory,
            cafeDescription: tempDescription,
            cafePathImage: path,
            cafePhoneNumber: tempPhoneNumber,
            cafeTimeDescription: tempTimeDescription,
          );
          LoadingPopup.show("Loading..",context);
          await DatabaseService.addCafe(fileImage, tempCafe);
          Navigator.pop(context);
        } else {
          CafeInfoModel tempCafe = new CafeInfoModel(
            id: widget.cafe.id,
            cafeName: tempName,
            cafeAddress: tempAddress,
            cafeCategory: cafeCategory,
            cafeDescription: tempDescription,
            cafePathImage: path,
            cafePhoneNumber: tempPhoneNumber,
            cafeTimeDescription: tempTimeDescription,
          );
          LoadingPopup.show("Loading..",context);
          await DatabaseService.updateCafe(fileImage, tempCafe);
          Navigator.pop(context);
        }
        return "success";
      } catch (e) {
        return "error";
      }
    }
  }

  _confimrmData(fileImage, tempCafe) async {
    print("SUCCESS");
  }

  _textFieldStyle(hintText) => InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      );

  Text _textHeader(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16.0),
      textAlign: TextAlign.left,
    );
  }

  TextField _textField(controller, hintText) {
    return TextField(
      controller: controller,
      decoration: _textFieldStyle(hintText),
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  }

  Widget _buildFormatCafeName() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textHeader("ชื่อร้าน"),
          _textField(cafeNameController, "เพิ่มชื่อร้านค้า"),
        ],
      ),
    );
  }

  Widget _buildFormatcafeDescription() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textHeader("รายละเอียดร้าน"),
          _textField(cafeDescriptionController, "เพิ่มรายละเอียดร้าน"),
        ],
      ),
    );
  }

  Widget _buildFormatAddress() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textHeader("ที่อยู่"),
          _textField(cafeAddressController, "เพิ่มรายละเอียดที่อยู่"),
        ],
      ),
    );
  }

  Widget _buildFormatPhoneNumber() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textHeader("เบอร์ติดต่อ"),
          TextField(
            controller: cafePhoneNumberController,
            decoration: _textFieldStyle("เพิ่มเบอร์ติดต่อ"),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFormatTimeName() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textHeader("เวลาเปิด-ปิด"),
          _textField(cafeTimeController, "เพิ่มเวลาเปิด-ปิด"),
        ],
      ),
    );
  }

  Widget _buildFormatCategoryName() {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textHeader("ประเภทร้าน"),
          DropdownButton<String>(
            value: cafeCategory,
            hint: Text("เลือกประเภทร้าน"),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            onChanged: (String newValue) {
              setState(() {
                cafeCategory = newValue;
              });
            },
            items: <String>[
              'คาเฟ่มินิมอล',
              'คาเฟ่วินเทจ',
              'คาเฟ่ดอกไม้',
              'คาเฟ่นั่งทำงาน'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadImage() {
    return InkWell(
      onTap: () {
        chooseFile();
      },
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        height: 70,
        color: Color(0x000000).withOpacity(0.5),
        child: Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> chooseFile() async {
    File pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) _cropImage(pickedFile.path);
  }

  _cropImage(filePath) async {
    File cropFile = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxHeight: 270,
      maxWidth: 480,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.ratio16x9,
            ]
          : [
              CropAspectRatioPreset.ratio16x9,
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
    if (cropFile != null) {
      setState(() {
        imageText = "";
        this.fileImage = cropFile;
      });
    }
  }
}
