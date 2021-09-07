import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:myfitnessfire/models/exo_model.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/program_days_model.dart';
import 'package:myfitnessfire/models/programs_model.dart';
import 'package:myfitnessfire/pages/day_description.dart';
import 'package:myfitnessfire/pages/in_app_purchase.dart';
import 'package:myfitnessfire/structures/in_app_purchases.dart';
import 'package:myfitnessfire/structures/localizations.dart';
import 'package:myfitnessfire/structures/user_model.dart';

import '../words.dart';
import 'chat_page.dart';

class WorkoutPage extends StatefulWidget {
  static final tag = "workout_page";
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  bool isShop;
  bool isStoreAvailable;
  int currentProgramIndex;
  String userId;
  List<ProductDetails> products;
  List<String> urls = [];
  NewProgramModel currentProgram;
  List<ProgramDaysModel> daysList = [];
  List<ExoModel> exoList = [];
  List<List<ExoModel>> exoLists = [];
  Future<void> _programContent;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  UserModel _userInstance = UserModel().getInstance();

  @override
  void initState() {
    super.initState();
    //_programContent = _fetchProgramContent();
  }

  Future<void> _fetchProgramContent(bool isShop) async {
    // When opened from shop page
    if (isShop) {
      await db
          .collection("Programs")
          .doc(currentProgram.programId)
          .collection("Content")
          .orderBy("dayNumber")
          .get()
          .then((QuerySnapshot snapshot) => {
                snapshot.docs.forEach((doc) async {
                  ProgramDaysModel programDay =
                      ProgramDaysModel().fromMap(doc.data());
                  daysList.add(programDay);
                })
              });

      for (int i = 0; i < daysList.length; i++) {
        exoList = [];
        await db
            .collection("Programs")
            .doc(currentProgram.programId)
            .collection("Content")
            .doc(daysList[i].dayId)
            .collection("Exo")
            .orderBy("exoNumber")
            .get()
            .then((QuerySnapshot snapshot) => {
                  snapshot.docs.forEach((doc) async {
                    exoList.add(ExoModel().fromMap(doc.data()));
                    print(doc.data());
                  })
                });
        exoLists.add(exoList);
      }
    }
    // When opened from my programs page
    else {
      await db
          .collection("Users")
          .doc(_userInstance.userId)
          .collection("purchased")
          .doc(currentProgram.programId)
          .collection("Content")
          .orderBy("dayNumber")
          .get()
          .then((QuerySnapshot snapshot) => {
                snapshot.docs.forEach((doc) async {
                  ProgramDaysModel programDay =
                      ProgramDaysModel().fromMap(doc.data());
                  daysList.add(programDay);
                })
              });

      for (int i = 0; i < daysList.length; i++) {
        exoList = [];
        await db
            .collection("Users")
            .doc(_userInstance.userId)
            .collection("purchased")
            .doc(currentProgram.programId)
            .collection("Content")
            .doc(daysList[i].dayId)
            .collection("Exo")
            .orderBy("exoNumber")
            .get()
            .then((QuerySnapshot snapshot) => {
                  snapshot.docs.forEach((doc) async {
                    exoList.add(ExoModel().fromMap(doc.data()));
                    print(doc.data());
                  })
                });
        exoLists.add(exoList);
      }
    }

    for (var i = 0; i < daysList.length; i++) {
      int j = i + 1;
      if (j > 7) {
        j = 1;
      }
      String refURL;
      if (currentProgram.storage != NewProgramModel.nullValue) {
        refURL =
            "${currentProgram.storage}/${currentProgram.storage}${(j)}.jpg";
      } else {
        refURL = "errorStorageHolder.jpg";
      }
      Reference ref = firebaseStorage.ref().child(refURL);
      await ref.getDownloadURL().then((value) {
        urls.add(value);
      }).catchError((e) {
        print('ERROR: $e');
        throw "Check your Internet connection";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    isShop = arguments[0];
    currentProgramIndex = arguments[1];
    currentProgram = arguments[2];
    isStoreAvailable = arguments[3];

    _programContent = _fetchProgramContent(isShop);

    final bool isLight = Theme.of(context).brightness == Brightness.light;
    String translate(context, words) {
      return AppLocalizations.of(context).translate(words);
    }

    return Scaffold(
      appBar: PreferredSize(
        child: _appBarTitle(
            isLight: isLight, textCancel: translate(context, Words.cancel)),
        preferredSize: Size.fromHeight(56),
      ),
      body: FutureBuilder(
        future: _programContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return SingleChildScrollView(
                child: Column(
                    children: List.generate(daysList.length, (index) {
              double height = 180;
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(DayDescriptionPage.tag, arguments: [
                    urls[7 % (7 - index)], //TODOs -> Verify
                    isShop,
                    currentProgram,
                    daysList[index],
                    exoLists[index],
                  ]);
                },
                child: Stack(
                  children: [
                    _imageButton(
                        urls: urls,
                        index: index,
                        height: height,
                        isLight: isLight),
                  ],
                ),
              );
            })));
          }
        },
      ),
      bottomNavigationBar: isShop
          ? _bottomAppBar(
              translate: (context, words) => translate(context, words),
              isLight: isLight)
          : null,
    );
  }

  Widget _appBarTitle({isLight, textCancel}) {
    return Container(
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
        title: Text(
          isShop ? currentProgram.programName : currentProgram.programName,
          style: TextStyle(),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: [
          isShop
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${currentProgram.price} \$CAN",
                    style: TextStyle(fontSize: 16),
                  ),
                ))
              // IconButton(
              //     icon: Icon(
              //       Icons.info,
              //     ),
              //     onPressed: () {
              //       _infoPrice(
              //         context: context,
              //         textCancel: textCancel,
              //         textTitle: isShop
              //             ? ProgramsModel.programNames[currentProgramIndex]
              //             : MyProgramsModel.programNames[currentProgramIndex],
              //       );
              //     },
              //   )
              : IconButton(
                  icon: Icon(
                    Icons.chat,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ChatPage.tag, arguments: [
                      currentProgram.programId,
                      _userInstance.userId,
                      WorkoutPage.tag,
                      currentProgram.programName,
                    ]);
                  },
                )
        ],
      ),
    );
  }

  Widget _imageButton(
      {List<String> urls, int index, double height, bool isLight}) {
    return Container(
      margin: EdgeInsets.only(
          left: 10, right: 10, bottom: 10, top: index == 0 ? 10 : 0),
      width: double.infinity,
      height: height,
      child: ClipRRect(
        child: GridTile(
          child: Hero(
            tag: "test" + daysList[index].dayNumber,
            child: Image.network(
              urls[7 % (7 - index)],
              fit: BoxFit.cover,
            ),
          ),
          footer: Container(
            height: 50,
            color: Colors.black.withOpacity(0.6),
            child: ListTile(
              title: Text(
                "Day " + daysList[index].dayNumber,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              trailing: Text(
                isShop
                    ? daysList[index].dayName ?? ProgramsModel.nullValue
                    : daysList[index].dayName ?? ProgramsModel.nullValue,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _bottomAppBar({String translate(context, words), bool isLight}) {
    return BottomAppBar(
      child: InkWell(
        onTap: () {
          //   final ProductDetails productDetails = ... // Saved earlier from queryPastPurchases().
          //Navigator.of(context).pushNamed(AppPurch.tag);

          /*final PurchaseParam purchaseParam =
              PurchaseParam(productDetails: products[currentProgramIndex]);

          InAppPurchaseConnection.instance
              .buyNonConsumable(purchaseParam: purchaseParam);*/

//This is a page I was not sure about...
          //InAppPurchaseConnection.completePurchase;
          // Add a copy of program to user's DB

          _buyProgram();
        },
        child: Container(
          height: 50,
          color: isLight
              ? Color.fromRGBO(250, 250, 250, 1)
              : Color.fromRGBO(20, 20, 20, 1),
          child: Center(
            child: Text(translate(context, Words.purchase),
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  Future _infoPrice({context, textCancel, textTitle}) {
    ThemeData themeData = Theme.of(context);
    bool isLight = themeData.brightness == Brightness.light;
    return showDialog(
      context: context,
      builder: (BuildContext contextPopUp) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(textCancel),
            )
          ],
          title: Text(textTitle),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Price:')),
                    Text(
                      ProgramsModel.price[currentProgramIndex].toString() +
                          ' \$CAD',
                    )
                  ],
                ),
                Divider(color: Colors.grey),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Subtotal:'),
                    ),
                    Text(ProgramsModel.price[currentProgramIndex].toString() +
                        ' \$CAD')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Estimated Tax: '),
                    ),
                    Text(
                      (double.parse((ProgramsModel.price[currentProgramIndex] *
                                      0.14975)
                                  .toStringAsFixed(2)))
                              .toString() +
                          ' \$CAD',
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text('Total: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                    Text(
                        (double.parse(
                                    (ProgramsModel.price[currentProgramIndex] *
                                            1.14975)
                                        .toStringAsFixed(2)))
                                .toString() +
                            ' \$CAD',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Firefit is required by law to collect applicable transaction taxes for purchases',
                        style: TextStyle(
                            color: isLight ? Colors.black54 : Colors.white54,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _buyProgram() async {
    bool result = await InAppPurchases().buyProduct(currentProgram.programId);
    if(result){
      _addProgramInformation();
    }
    else
      print("Purchase Unsuccessful");
  }

  Future<void> _addProgramInformation() async {
    await db
        .collection("Users")
        .doc(_userInstance.userId)
        .collection("purchased")
        .doc(currentProgram.programId)
        .set(NewProgramModel().toMap(currentProgram), SetOptions(merge: true))
        .catchError((error) => print("Failed to add program: $error"));

    for (int i = 0; i < daysList.length; i++) {
      await db
          .collection("Users")
          .doc(_userInstance.userId)
          .collection("purchased")
          .doc(currentProgram.programId)
          .collection("Content")
          .doc(daysList[i].dayId)
          .set(ProgramDaysModel().toMap(daysList[i]), SetOptions(merge: true))
          .catchError((error) => print("Failed to add program: $error"));

      exoList = exoLists[i];

      for (int j = 0; j < exoList.length; j++) {
        await db
            .collection("Users")
            .doc(_userInstance.userId)
            .collection("purchased")
            .doc(currentProgram.programId)
            .collection("Content")
            .doc(daysList[i].dayId)
            .collection("Exo")
            .add(ExoModel().toMap(exoList[j]))
            .catchError((error) => print("Failed to add program: $error"));
      }
    }
    return null;
  }
}
