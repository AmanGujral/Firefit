import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfitnessfire/pages/change_language.dart';
import 'package:myfitnessfire/pages/settings.dart';
import 'package:myfitnessfire/structures/authentifiations.dart';
import 'package:myfitnessfire/structures/localizations.dart';
import 'package:myfitnessfire/words.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    User user = Provider.of<User>(context);

    String translate(context, words) {
      return AppLocalizations.of(context).translate(words);
    }

    return Scaffold(
      appBar: PreferredSize(
        child: _appBar(
          statusBarHeight: statusBarHeight,
          translate: (context, words) => translate(context, words),
        ),
        preferredSize: Size.fromHeight(56),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Info(
              image: "images/circle_firefit.png",
              name: user.email.split("@")[0] ?? "",
              email: user.email,
            ),
            SizedBox(height: 20), //20
            // ProfileMenuItem(
            //   iconSrc: Icons.edit,
            //   title: "Saved Recipes",
            //   press: () {},
            // ),
            ProfileMenuItem(
              iconSrc: Icons.invert_colors,
              title: translate(context, Words.themePreference),
              press: () {
                Navigator.of(context).pushNamed(SettingsPage.tag);
              },
            ),
            ProfileMenuItem(
              iconSrc: Icons.language,
              title: translate(context, Words.changeLanguage),
              press: () {
                Navigator.of(context).pushNamed(ChangeLanguagePage.tag);
              },
            ),
            ProfileMenuItem(
              iconSrc: Icons.exit_to_app,
              title: translate(context, Words.disconnection),
              press: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            translate(context, Words.disconnection),
                          ),
                          content: Text(translate(context, Words.areYouSure)),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(translate(context, Words.cancel)),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                signOut();
                              },
                              child:
                                  Text(translate(context, Words.disconnection)),
                            )
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar({statusBarHeight, String translate(context, words)}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56),
      child: Container(
        height: 56 + statusBarHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0.0,
          title: Text(
            translate(context, Words.profile),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    Key key,
    this.name,
    this.email,
    this.image,
  }) : super(key: key);
  final String name, email, image;

  @override
  Widget build(BuildContext context) {
    double defaultSize = 10;
    ThemeData themeData = Theme.of(context);
    return SizedBox(
      height: defaultSize * 20, // 240
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 15, //150
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: defaultSize), //10
                  height: defaultSize * 10, //140
                  width: defaultSize * 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      themeData.primaryColor,
                      themeData.accentColor
                    ]),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.5, //8
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image),
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: defaultSize * 2.2, // 22
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(height: defaultSize / 2), //5
                Text(
                  email,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8492A2),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key key,
    this.iconSrc,
    this.title,
    this.press,
  }) : super(key: key);
  final IconData iconSrc;
  final String title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    double defaultSize = 10;
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2, vertical: defaultSize * 3),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              Icon(
                iconSrc,
                color: isLight
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.3),
              ),
              SizedBox(width: defaultSize * 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: defaultSize * 1.6, //16
                  color: isLight
                      ? Colors.black.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                ),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: defaultSize * 1.6,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
