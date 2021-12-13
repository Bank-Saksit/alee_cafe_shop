import 'package:cafe_app/core/service/data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
        title: Text('สมัครสมาชิก'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        )),
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(context),
                    SizedBox(height: height * .14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'อีเมล',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: emailController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }


  Widget buildTextFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'รหัสผ่าน',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget buildTextFieldPasswordConfirm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ยืนยันรหัสผ่าน',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: passwordConfirmController,
              obscureText: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
  

  Widget _submitButton(context) {
    return InkWell(
      onTap: () async {
        String text = await signUp(context);
        _showDialog(text);
        print(text);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
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
            ],
          ),
        ),
        child: Text(
          'ยืนยันการสมัครสมาชิก',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'ALEE',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: ' Coffee ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'SHOP',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        buildTextFieldEmail(),
        buildTextFieldPassword(),
        buildTextFieldPasswordConfirm(),
      ],
    );
  }

  Future<String> signUp(context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = passwordConfirmController.text.trim();
    print(password);
    print(confirmPassword);

    String text;
    if (password.length < 6) {
      text = 'กรุณากรอกรหัสผ่านจำนวนตัวอักษรมากกว่า 6 ตัว';
    } else if (password != confirmPassword) {
      text = 'กรุณากรอกรหัสผ่านและยืนยันรหัสผ่านให้ตรงกัน';
    } else {
      try {
        FirebaseAuth _auth = FirebaseAuth.instance;
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password,);
        User user = FirebaseAuth.instance.currentUser;
        user.updateProfile(
          displayName: user.email,
          photoURL: "profile/default.png"
        );
        user.sendEmailVerification();
        DatabaseService.addUserInfo(user);
        _auth.signOut();

        text = 'การสมัครรหัสผ่านสำเร็จ กรุณายืนยันอีเมล';
        emailController.text = "";
        passwordController.text = "";
        passwordConfirmController.text = "";
      } catch (e) {
        print("ERROR REGISTER");
        print(e.message);
        print(e.code);
        String text = e.message;
        switch (e.code) {
          case "invalid-email":
            text = "รูปแบบอีเมลไม่ถูกต้อง";
            break;
          case "email-already-in-use":
            text = "อีเมลนี้มีการใช้งานแล้ว";
            break;
          default:
            text = "เกิดข้อผิดพลาดในการสมัคร";
        }

        return text;
      }
    }
    return text;
  }

  _showDialog(String text) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
            child: Container(
          width: MediaQuery.of(context).size.width - 50,
          height: 150,
          padding: EdgeInsets.all(20),
          color: Color(0x000000).withOpacity(0.8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
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
                  color: Colors.black,
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
