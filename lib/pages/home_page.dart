import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfitnessfire/pages/account_page.dart';
import 'package:myfitnessfire/pages/all_chats_page.dart';
import 'package:myfitnessfire/pages/my_programs.dart';
import 'package:myfitnessfire/pages/shop_page.dart';
import 'package:myfitnessfire/pages/workout.dart';
import 'package:myfitnessfire/providers/user_preferences.dart';
import 'package:myfitnessfire/structures/user_model.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_drawer.dart';

import '../structures/localizations.dart';

import '../words.dart';

class HomePage extends StatefulWidget {
  //final User user;
  //HomePage({this.user});
  static const tag = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  UserModel _userInstance = UserModel().getInstance();

  String translate(context, words) {
    return AppLocalizations.of(context).translate(words);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    List<Widget> _widgetOptions = <Widget>[
      ShopPage(
        //user: widget.user,
      ),
      ProgramsPage(
          callBack: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          //user: widget.user
      ),
      if(_userInstance.isSeller)
        AllChatsPage(),
      AccountPage(),
    ];
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        unselectedItemColor: isLight ? Colors.black54 : Colors.white54,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            //  label: translate(context, Words.home),
            title: Text(translate(context, Words.home)),
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            //label: translate(context, Words.myPrograms),
            title: Text(translate(context, Words.myPrograms)),
            icon: Icon(
              Icons.list,
            ),
          ),
          if(_userInstance.isSeller)
            BottomNavigationBarItem(
              //label: translate(context, Words.chats),
              title: Text(translate(context, Words.chats)),
              icon: Icon(
                Icons.chat_rounded,
              ),
            ),
          BottomNavigationBarItem(
            //label: translate(context, Words.profile),
            title: Text(translate(context, Words.profile)),
            icon: Icon(
              Icons.person,
            ),
          )
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 200);
    path.lineTo(size.width, 150);
    path.lineTo(size.width, 0);
    //path.lineTo(30, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
