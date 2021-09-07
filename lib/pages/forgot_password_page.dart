import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfitnessfire/providers/user_preferences.dart';
import 'package:myfitnessfire/widgets/brazier.dart';
import 'package:provider/provider.dart';
import '../structures/authentifiations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const tag = "forgot_password_page";
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String errorMessage = "";

  TextEditingController _controllerEmail = TextEditingController();

  Future<void> sendPasswordResetEmail() async {
    try {
      await Auth().sendPasswordResetEmail(email: _controllerEmail.text).then(
          (value) => Navigator.of(context)
              .pop("Sent email with password reset instructions"));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
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
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: title,
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
      onTap: sendPasswordResetEmail,
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
          'Retrive password',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
              text: 'Forgot Password',
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
