import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitnessfire/structures/user_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';

class WidgetTree extends StatelessWidget {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserModel _userInstance = UserModel().getInstance();

  Future<void> _reload({User user}) async {
    await user.reload();
    await _firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .get()
        .then((value) => {
      _userInstance.fromMap(value.data())
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return FutureBuilder(
      future: _reload(user: user),
      // future: reauthenticateWithCredential(email: user.email, password: user.),
      builder: (context, snapshot) {
        if (user == null) {
          return LoginPage();
        }
        print("UID: ${user.uid}");
        /*_firebaseFirestore
            .collection("Users")
            .doc(user.uid)
            .get()
            .then((value) => {
          _userInstance.fromMap(value.data())
        });*/
        return  HomePage();
      },
    );
  }
}
