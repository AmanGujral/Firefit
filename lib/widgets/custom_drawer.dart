import 'package:flutter/material.dart';
import 'package:myfitnessfire/structures/localizations.dart';

import '../pages/settings.dart';
import '../structures/authentifiations.dart';
import '../words.dart';

class CustomDrawer extends StatelessWidget {
  Future<void> signOut() async {
    await Auth().signOut();
  }

  String translate(context, words) {
    return AppLocalizations.of(context).translate(words);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListTileTheme(
        style: ListTileStyle.drawer,
        child: ListView(
          children: [
            DrawerHeader(
              child: ListTile(
                title: Text("My Fitness Fire"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(translate(context, Words.settings)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsPage.tag);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(translate(context, Words.disconnection)),
              onTap: signOut,
            ),
          ],
        ),
      ),
    );
  }
}
