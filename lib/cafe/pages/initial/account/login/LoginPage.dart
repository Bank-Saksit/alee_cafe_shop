import 'package:cafe_app/cafe/blocs/authentication/bloc.dart';
import 'package:cafe_app/cafe/blocs/navigation/bottom_navigation_bloc.dart';
import 'package:cafe_app/cafe/pages/initial/account/signup/SignUpPage.dart';
import 'package:cafe_app/widgets/side_bar.dart';
import 'package:cafe_app/widgets/tab_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final BottomNavigationBloc navigationBloc;
  final AuthenticationBloc authenBloc;

  const LoginPage({
    Key key,
    @required this.navigationBloc,
    @required this.authenBloc,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //checkAuth(context);
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: isPassword ? passwordController : emailController,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        String textError = await signIn(context);
        if (textError != 'Success')
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black45,
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (BuildContext buildContext, Animation animation,
                Animation secondaryAnimation) {
              return Center(
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
                          textError,
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
              );
            },
          );
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
                ])),
        child: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'คุณมีบัญชีแล้วหรือไม่?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'สมัครสมาชิก',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
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
        _entryField("ชื่อผู้ใช้งาน"),
        _entryField("รหัสผ่าน", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 100, 100, 1),
        title: Text('เข้าสู่ระบบ'),
      ),
      drawer: SideBarManual(
        bloc: widget.navigationBloc,
      ),
      bottomNavigationBar: TabBarNavigation(
        bloc: widget.navigationBloc,
        index: 3,
      ),
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              height: 1000,
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    _title(),
                    SizedBox(height: 50),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> signIn(BuildContext context) async {
    try {
      var email = emailController.text.trim();
      var password = passwordController.text.trim();
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) => (user.user.email));
      User user = _auth.currentUser;
      if(user != null){
        if (user.emailVerified) {
          print("URL : " + user.photoURL);
          widget.authenBloc.add(LoggedIn());
          return 'Success';
        } else {
          _auth.signOut();
          return 'กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ';
        }
      }
    } catch (e) {
      print("ERROR ");
      print(e.message);
      print(e.code);
      String text;
      switch (e.code) {
          case "invalid-email":
            text = "รูปแบบอีเมลไม่ถูกต้อง";
            break;
          case "user-not-found":
            text = "ไม่มีอีเมลผู้ใช้งานในระบบ";
            break;
          case "wrong-password":
            text = "รหัสผ่านผิดพลาด";
            break;
          default:
            text = "เกิดข้อผิดพลาดในเข้าสู่ระบบ";
        }
      passwordController.text = "";
      return (text);
    }
  }
}
