import 'package:flutter/material.dart';
import 'package:myfitnessfire/providers/user_preferences.dart';
import 'package:myfitnessfire/widgets/brazier.dart';
import 'package:provider/provider.dart';
import '../structures/authentifiations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  static const tag = "sign_up_page";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String errorMessage = "";
  bool showPassword = false;

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInAnonymously() async {
    try {
      await Auth()
          .signInAnonymously()
          .then((value) => Navigator.of(context).pop());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      await Auth()
          .signInWithFacebook()
          .then((value) => Navigator.of(context).pop());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth()
          .signInWithGoogle()
          .then((value) => Navigator.of(context).pop());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      print(_controllerEmail.text);
      await Auth()
          .createUserWithEmailAndPassword(
              email: _controllerEmail.text, password: _controllerPassword.text)
          .whenComplete(() => Navigator.of(context).pop())
          .catchError((Object error) => print(error.toString()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
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
      onTap: createUserWithEmailAndPassword,
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
          'Register with Email',
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
              'Register with Facebook',
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
              'Register with Google',
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
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign in',
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
          text: '',
          style: GoogleFonts.encodeSansSemiCondensed(
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'Welcome',
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
        Positioned(top: 40, left: 0, child: _backButton()),
      ],
    ));
  }
}
