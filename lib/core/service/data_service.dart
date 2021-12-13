import 'dart:io';

import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  static List<CafeInfoModel> listCafe;

  static bool changeData = false;
  static String profileImagePath = "";
  static String userRole;
  
  static Future<List<CafeInfoModel>> getCafeInfo() async {
    if (listCafe == null || changeData == true) {
      print("Loading");
      List<CafeInfoModel> cafes = List<CafeInfoModel>();
      var snapshot =
          await FirebaseDatabase.instance.reference().child("cafe").once();
      Map<dynamic, dynamic> values = snapshot.value;
      for (final data in values.values) {
        cafes.add(CafeInfoModel.fromSnapshot(data));
      }
      int i = 0;
      for (final data in values.keys) {
        cafes[i].id = data;
        i++;
      }
      listCafe = cafes;
    }
    return listCafe;
  }

  static Future<void> addCafe(File fileImage, CafeInfoModel cafe) async {
    changeData = true;
    var storageReference =
        FirebaseStorage.instance.ref().child(cafe.cafePathImage);
    if (fileImage != null) {
      await storageReference.putFile(fileImage);
      cafe.cafePathImage = await storageReference.getDownloadURL();
    }
    DatabaseReference _userRef =
        FirebaseDatabase.instance.reference().child('cafe');
    _userRef.push().set(cafe.toJson()).then((_) {
      print('Transaction  committed.');
    });
  }

  static Future<void> updateCafe(File fileImage, CafeInfoModel cafe) async {
    changeData = true;
    var storageReference =
        FirebaseStorage.instance.ref().child(cafe.cafePathImage);
    if (fileImage != null) {
      await storageReference.putFile(fileImage);
      cafe.cafePathImage = await storageReference.getDownloadURL();
    }

    DatabaseReference _userRef =
        FirebaseDatabase.instance.reference().child('cafe');
    if (fileImage == null) {
      await _userRef.child(cafe.id).update({
        "cafeName": cafe.cafeName,
        "cafeDescription": cafe.cafeDescription,
        "cafeAddress": cafe.cafeAddress,
        "cafeTimeDescription": cafe.cafeTimeDescription,
        "cafePhoneNumber": cafe.cafePhoneNumber,
        "cafeCategory": cafe.cafeCategory,
      }).then((_) {
        print('Transaction  committed.');
      });
    } else {
      await _userRef.child(cafe.id).update({
        "cafeName": cafe.cafeName,
        "cafeDescription": cafe.cafeDescription,
        "cafeAddress": cafe.cafeAddress,
        "cafePathImage": cafe.cafePathImage,
        "cafeTimeDescription": cafe.cafeTimeDescription,
        "cafePhoneNumber": cafe.cafePhoneNumber,
        "cafeCategory": cafe.cafeCategory,
      }).then((_) {
        print('Transaction  committed.');
      });
    }
      print("TEST255555");

  }

  static Future<void> delectCafe(CafeInfoModel cafe) async {
    changeData = true;

    DatabaseReference _userRef =
        FirebaseDatabase.instance.reference().child('cafe');

    await _userRef.child(cafe.id).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  static Future<void> getRole(User user) async {
    var snapshot = await FirebaseDatabase.instance.reference().child("user").child(user.uid).once();
    Map<dynamic, dynamic> values = snapshot.value;
    userRole = values["role"];
  }

  static Future<void> addUserInfo(User user) async {
    DatabaseReference _userRef =
        FirebaseDatabase.instance.reference().child('user');

    Map<String,dynamic> userData = {
      "name" : user.displayName,
      "email" : user.email,
      "role" : "user",
    };
    _userRef.child(user.uid).set(userData).then((_) {
      print('Transaction  committed.');
    });
  }
}
