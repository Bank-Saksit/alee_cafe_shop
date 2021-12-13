import 'package:cafe_app/cafe/models/cafe_info.dart';
import 'package:cafe_app/widgets/loading_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CafeCommentPage extends StatefulWidget {
  final CafeInfoModel cafe;

  const CafeCommentPage({Key key, @required this.cafe}) : super(key: key);

  @override
  _CafeCommentPageState createState() => _CafeCommentPageState();
}

class _CafeCommentPageState extends State<CafeCommentPage> {
  TextEditingController commentController = new TextEditingController();
  User user = FirebaseAuth.instance.currentUser;

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
          title: Text("เขียนรีวิว"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user == null ? widget.cafe.cafeName : 'รีวิวร้าน',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10.0),
                    user != null ? _buildUserName() : SizedBox(),
                    SizedBox(height: 10.0),
                    user != null ? _buildTextFieldComment() : SizedBox(),
                    user != null
                        ? SizedBox(
                            height: 20,
                          )
                        : SizedBox(),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("comment")
                          .doc(widget.cafe.id)
                          .collection("sequence")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Text("Loading . . . "),
                              ],
                            ),
                          );
                        } else {
                          return snapshot.data.docs.length == 0
                              ? SizedBox()
                              : _buildReviewBox(snapshot);
                        }
                      },
                    )
                  ],
                )),
          ),
        ));
  }

  _buildUserName() {
    return Text(
      user.displayName,
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
    );
  }

  _buildTextFieldComment() {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        TextField(
          controller: commentController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 3,
          decoration: InputDecoration(
            hintText: 'บอกเล่าประสบการณ์การเยี่ยมชมของคุณ',
            hintStyle: TextStyle(),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        RaisedButton(
          onPressed: () {
            _updateComment();
          },
          child: Text('ยืนยัน', style: TextStyle(color: Colors.white)),
          color: Colors.grey,
        ),
      ]),
    );
  }

  _buildReviewBox(var snapshot) {
    return Column(
        children: List.generate(snapshot.data.docs.length, (index) {
      return Container(
        margin: EdgeInsets.only(bottom: 8.0),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(children: [
                user == null
                    ? SizedBox()
                    : user.email != snapshot.data.docs[index].data()["email"]
                        ? SizedBox()
                        : InkWell(
                            onTap: () {
                              myDialog(
                                  "ลบคอมเม้นท์", snapshot.data.docs[index].id);
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                Row(
                  children: [
                    _imageProfile(
                        snapshot.data.docs[index].data()["urlProfile"]),
                    SizedBox(width: 8.0),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data.docs[index].data()["email"],
                          ),
                          SizedBox(height: 10.0),
                          Text(readTimestamp(
                              snapshot.data.docs[index].data()["time"])),
                        ]),
                  ],
                ),
              ]),
              SizedBox(height: 10.0),
              _buildBorder(),
              SizedBox(height: 10.0),
              Text(snapshot.data.docs[index].data()["comment"]),
            ],
          ),
        ),
      );
    }));
  }

  _imageProfile(pathImage) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(300),
        border: Border.all(
          color: Colors.black,
        ),
        image: DecorationImage(
          image: NetworkImage(pathImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('dd/MM/y hh:mm');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  _updateComment() async {
    LoadingPopup.show("Loading..", context);
    var comment = commentController.text.trim();
    User user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance.ref().child(user.photoURL);
    var urlProfile = await ref.getDownloadURL();
    print(widget.cafe.id);
    if (comment == "") {
    } else {
      FirebaseFirestore.instance
          .collection("comment")
          .doc(widget.cafe.id)
          .collection("sequence")
          .add({
        "email": user.email,
        "comment": comment,
        "time": DateTime.now().millisecondsSinceEpoch,
        "urlProfile": urlProfile
      }).then((value) {
        print(value.id);
        commentController.text = "";
      });
    }
    Navigator.pop(context);
  }

  Widget _buildBorder() {
    return Container(
        decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1.0,
          color: Colors.black12,
        ),
      ),
    ));
  }

  myDialog(text, docId) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        onPressed: () {
                          print(docId);
                          FirebaseFirestore.instance
                              .collection("comment")
                              .doc(widget.cafe.id)
                              .collection("sequence")
                              .doc(docId)
                              .delete();

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "ตกลง",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      )
                    ],
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
