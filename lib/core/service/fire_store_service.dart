import 'package:cafe_app/cafe/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FireStoreService {
  static FirebaseFirestore  firestore= FirebaseFirestore.instance;

  // Stream<List<Comment>> getComment(String id) {
  static Stream<List<Comment>> getComment(String id)  {
    // return firestore.collection("comment").doc("MSd4CnvkJVnOI3fVKHs").collection("order").snapshots();
  }
}