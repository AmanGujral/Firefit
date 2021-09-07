import 'package:flutter/material.dart';
import 'package:myfitnessfire/providers/user_preferences.dart';
import 'package:myfitnessfire/widgets/brazier.dart';
import 'package:provider/provider.dart';
import '../structures/authentifiations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'forgot_password_page.dart';

import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMessage = "";
  bool showPassword = false;

  TextEditingController _controllerEmail = TextEditingController(text: "lppapineau@gmail.com");
  TextEditingController _controllerPassword = TextEditingController(text: "112233");

  Future<void> signInAnonymously() async {
    try {
      await Auth().signInAnonymously();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      await Auth().signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      print(_controllerEmail.text);
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: showPassword ? false : isPassword,
        decoration: InputDecoration(
          labelText: title,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Color.fromRGBO(40, 40, 40, 1),
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  })
              : null,
          labelStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color.fromRGBO(40, 40, 40, 1)
                  : Color.fromRGBO(240, 240, 240, 1)),
          focusedBorder: UnderlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.light
                    ? Color.fromRGBO(40, 40, 40, 1)
                    : Color.fromRGBO(240, 240, 240, 1),
                width: 2.0),
          ),
          filled: true,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: signInWithEmailAndPassword,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.red, Color(0xffe46b10)])),
        child: Text(
          'Sign in with Email',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _facebook() {
    return InkWell(
      onTap: signInWithFacebook,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff1877F2), Color(0xff1877F2)])),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Image.asset(
              "images/facebook.png",
              height: 20,
            ),
            Spacer(),
            Text(
              'Sign in with Facebook',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Spacer(),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _google() {
    return InkWell(
      onTap: signInWithGoogle,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).brightness == Brightness.light
                ? Color.fromRGBO(40, 40, 40, 1)
                : Color.fromRGBO(240, 240, 240, 1)),
        child: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Image.asset(
              "images/google.png",
              height: 20,
            ),
            Spacer(),
            Text(
              'Sign in with Google',
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color.fromRGBO(240, 240, 240, 1)
                      : Color.fromRGBO(40, 40, 40, 1)),
            ),
            Spacer(),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(SignUpPage.tag);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic),
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
          text: 'My',
          style: GoogleFonts.encodeSansSemiCondensed(
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: ' Fitness Fire',
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color.fromRGBO(40, 40, 40, 1)
                      : Color.fromRGBO(240, 240, 240, 1)),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email", _controllerEmail),
        _entryField("Password", _controllerPassword, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final userPreferences = Provider.of<UserPreference>(context);
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          physics: ScrollPhysics(parent: null),
          child: Column(
            children: [
              Container(
                child: BezierContainer(),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: height * .1),
                _title(),
                SizedBox(height: 60),
                _facebook(),
                SizedBox(height: 10),
                _google(),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text('OR',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                _emailPasswordWidget(),
                SizedBox(height: 20),
                _submitButton(),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context)
                        .pushNamed(ForgotPasswordPage.tag);
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("$result")));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(errorMessage == "" ? "" : 'Humm ? $errorMessage',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: height * .055),
                _createAccountLabel(),
                IconButton(
                    icon: Icon(Theme.of(context).brightness == Brightness.light
                        ? Icons.brightness_4
                        : Icons.brightness_high),
                    onPressed: () {
                      Theme.of(context).brightness == Brightness.light
                          ? userPreferences.changeUiPreferences(2)
                          : userPreferences.changeUiPreferences(1);
                    })
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
