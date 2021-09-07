import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/program_model.dart';
import 'package:myfitnessfire/models/programs_model.dart';
import 'package:myfitnessfire/models/weekly_goals_model.dart';
import 'package:myfitnessfire/pages/workout.dart';
import 'package:myfitnessfire/providers/user_preferences.dart';
import 'package:myfitnessfire/structures/in_app_purchases.dart';
import 'package:myfitnessfire/structures/localizations.dart';
import 'package:myfitnessfire/structures/user_model.dart';
import 'package:myfitnessfire/widgets/search.dart';
import 'package:provider/provider.dart';
import 'package:myfitnessfire/widgets/programTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../words.dart';
import 'home_page.dart';

class ShopPage extends StatefulWidget {
  //final User user;
  //ShopPage({@required this.user});
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _colorTween, _iconColorTween, _colorTween2;
  Animation<Offset> _transTween;

  List<String> allUrl = [];
  bool isShop = true;
  bool isStoreAvailable;
  List<NewProgramModel> programsList = [];
  List<String> programIds = [];

  Future<void> _programsInformation;
  Future<void> _weeklyData;

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  UserModel _userInstance = UserModel().getInstance();
  WeeklyGoals _weeklyGoals;

  String translate(context, words) {
    return AppLocalizations.of(context).translate(words);
  }

  List<ProductDetails> products;

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.redAccent)
        .animate(_colorAnimationController);
    _colorTween2 = ColorTween(begin: Colors.transparent, end: Color(0xffe46b10))
        .animate(_colorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.white, end: Colors.white)
        .animate(_colorAnimationController);

    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_textAnimationController);

    super.initState();
    _programsInformation = _fetchProgramsInformation();
    _weeklyData = _fetchWeeklyData();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 90);

      _textAnimationController.animateTo((scrollInfo.metrics.pixels - 90) / 50);
      return true;
    }
    return false;
  }

  Future<void> _fetchWeeklyData() async {
    _weeklyGoals = WeeklyGoals().getInstance();
  }

  Future<void> _fetchProgramsInformation() async {
    programsList.clear();
    allUrl.clear();

    FirebaseFirestore db = FirebaseFirestore.instance;

    /*_weeklyGoals = WeeklyGoals().getInstance();
    weeklyGoals = _weeklyGoals.weekdays;
    print(weeklyGoals);*/

    await db.collection("Programs")
        .get()
        .then((QuerySnapshot snapshot) => {
      snapshot.docs.forEach((doc) async {
        programsList.add(NewProgramModel().fromMap(doc.data()));
        programIds.add(NewProgramModel().fromMap(doc.data()).programId);
      })
    });

    for (var i = 0; i < programsList.length; i++) {
      int j = i + 1;
      if(j > 7) {j = 1;}
      String refURL;
      if (programsList[i].storage != NewProgramModel.nullValue) {
        refURL =
        "${programsList[i].storage}/${programsList[i].storage}${(j)}.jpg";
      } else {
        refURL = "errorStorageHolder.jpg";
      }
      Reference ref = firebaseStorage.ref().child(refURL);
      await ref.getDownloadURL().then((value) {
        allUrl.add(value);
      }
      ).catchError((e) {
        print('ERROR: $e');
        throw "Check your Internet connection";
      });
    }


    // Initialize In App Purchases => Get all products, Get Past Purchases
    isStoreAvailable = await InAppPurchases().initialize(programIds);

    /*final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (!available) {
      // The store cannot be reached or accessed. Update the UI accordingly.
    } else {
      List<String> uidList = ["testing"];
      ProgramsModel.uidPrograms.forEach((uid) {
        uidList.add(uid.toLowerCase());
      });
      Set<String> _kIds = Set.from(uidList);
      print(_kIds);
      final ProductDetailsResponse response =
      await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        // Handle the error.
      }
      products = response.productDetails;
    }*/
    return null;
  }


  @override
  void dispose() {
    InAppPurchases().cancelSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final userPreferences = Provider.of<UserPreference>(context);
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        _backgroundStyle(),
                        Positioned(
                          top: 30,
                          left: size.width / 2 - 25,
                          child: Image.asset("images/circle_firefit.png"),
                          height: 50,
                        ),
                        _banner(size),
                      ],
                    ),
                    FutureBuilder(
                      initialData: [allUrl],
                      future: _programsInformation,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          print('waiting');
                          return Container(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return Column(
                            children: [
                              _category(translate(context, Words.programs),
                                  Icons.list),
                              _listOfPrograms(size),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              _appBar(userPreferences, statusBarHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(userPreferences, statusBarHeight) {
    return Container(
      height: 56 + statusBarHeight,
      child: AnimatedBuilder(
        animation: _colorAnimationController,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_colorTween.value, _colorTween2.value],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0.0,
            title: Transform.translate(
              offset: _transTween.value,
              child: Text(
                translate(context, Words.appName),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            iconTheme: IconThemeData(
              color: _iconColorTween.value,
            ),
            actions: [
              IconButton(
                icon: Icon(Theme.of(context).brightness == Brightness.light
                    ? Icons.brightness_4
                    : Icons.brightness_high),
                onPressed: () {
                  Theme.of(context).brightness == Brightness.light
                      ? userPreferences.changeUiPreferences(2)
                      : userPreferences.changeUiPreferences(1);
                },
              )
            ],
            leading: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search(products: products, allUrl:allUrl, programList: programsList));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner(size) {
    bool isLight = Theme.of(context).brightness == Brightness.light;

    return Positioned(
      top: 80,
      child: Container(
        width: size.width - 20,
        height: 120,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: isLight
                ? Color.fromRGBO(255, 255, 255, 1)
                : Color.fromRGBO(25, 25, 25, 1),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
              child: Row(
                children: [
                  Container(
                    child: Text(translate(context, Words.weeklyGoal)),
                  ),
                  Spacer(),
                  //Text("0/4")
                ],
              ),
            ),
            Spacer(),
            FutureBuilder(
                future: _weeklyData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('waiting');
                    return Container(
                      height: 50,
                      child: Center(
                        child: LinearProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          7,
                              (index) {
                            DateTime findFirstDateOfTheWeek(DateTime dateTime) {
                              return dateTime.subtract(
                                  Duration(days: dateTime.weekday - 1));
                            }

                            return Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _weeklyGoals.weekdays[index] == 'completed'
                                      ? Color(0xffe46b10)
                                      : isLight
                                      ? Colors.black.withOpacity(0.05)
                                      : Colors.white.withOpacity(0.1)),
                              /*color: weeklyGoals[index] == 'completed'
                                      ? Color(0xffe46b10)
                                      : isLight
                                      ? Colors.black.withOpacity(0.05)
                                      : Colors.white.withOpacity(0.1)),*/
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(10),
                              child: Text(
                                DateFormat('M-d')
                                    .format(
                                  findFirstDateOfTheWeek(DateTime.now())
                                      .add(
                                    Duration(days: index),
                                  ),
                                )
                                    .toString(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _backgroundStyle() {
    return Container(
      width: double.infinity,
      child: Container(
          height: 240,
          width: 500,
          child: Stack(children: [
            Container(color: Theme.of(context).scaffoldBackgroundColor),
            ClipPath(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.redAccent, Color(0xffe46b10)])),
              ),
              clipper: CustomClipPath(),
            )
          ])),
    );
  }

  Widget _category(title, IconData icon) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _listOfPrograms(size) {
    return Column(
        children: List.generate(
          programsList.length,
              (index) => InkWell(
            onTap: () async {
              Navigator.of(context).pushNamed(WorkoutPage.tag, arguments: [
                isShop,
                index,
                programsList[index],
                isStoreAvailable,
              ]);
            },
            child: FutureBuilder(
              future: _programsInformation,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  print('waiting');
                  return Container(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else
                  return ProgramTile().programTile(size, allUrl[index], programsList[index]);
              },
            ),),
        )
    );
  }
}
