import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myfitnessfire/models/my_programs_model.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/program_model.dart';
import 'package:myfitnessfire/pages/workout.dart';
import 'package:myfitnessfire/structures/localizations.dart';
import 'package:myfitnessfire/structures/user_model.dart';

import '../words.dart';

class ProgramsPage extends StatefulWidget {
  final Function(int) callBack;
  //final User user;
  //ProgramsPage({@required this.callBack, @required this.user});
  ProgramsPage({@required this.callBack});

  @override
  _ProgramsPageState createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  bool emptyPrograms = false;
  List<String> allUrl = [];
  List<NewProgramModel> programsList = [];
  Future<void> _myProgramsInformation;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  UserModel _userInstance = UserModel().getInstance();

  bool runFutureBuilder = true;

  final bool isShop = false;

  String translate(context, words) {
    return AppLocalizations.of(context).translate(words);
  }

  @override
  void initState() {
    super.initState();
    _myProgramsInformation = _fetchMyProgramsInformation();
  }

  Future<void> _fetchMyProgramsInformation() async {
    programsList.clear();
    allUrl.clear();

    await db.collection("Users")
        .doc(_userInstance.userId)
        .collection("purchased")
        .get()
        .then((QuerySnapshot snapshot) => {
      snapshot.docs.forEach((doc) async {
        programsList.add(NewProgramModel().fromMap(doc.data()));
      })
    });

    if(programsList.length == 0)
      emptyPrograms = true;
    else
      emptyPrograms = false;

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

    ///  runFutureBuilder = false;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: _appBar(context, statusBarHeight),
      body: FutureBuilder(
        future: runFutureBuilder ? _myProgramsInformation : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return Container(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return SingleChildScrollView(
              child: emptyPrograms
              // If programList is empty or user has not purchased any programs yet!
                  ? Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "You don't have any programs yet.We felt sorry for you, so we have added a pug.",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Make this pug happy.",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.add_box),
                          onPressed: () {
                            widget.callBack(0);
                          },
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      child: Image.asset(
                        "images/empty.jpg",
                        colorBlendMode: BlendMode.dstOut,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
              )
              // If programList is not empty.
                  : Column(
                children: [
                  _listOfPrograms(size, context),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _appBar(context, statusBarHeight) {
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
            translate(context, Words.appName),
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

  Widget _listOfPrograms(size, context) {
    return Column(
      children: List.generate(
        programsList.length,
            (index) => InkWell(
          onTap: () async {
            Navigator.of(context)
                .pushNamed(WorkoutPage.tag, arguments: [
              isShop,
              index,
              programsList[index],
              null,
            ]);
          },
          child: Container(
            width: size.width,
            height: 150,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
            child: ClipRRect(
              child: GridTile(
                footer: Container(
                  height: 50,
                  color: Colors.black.withOpacity(0.6),
                  child: ListTile(
                    title: Text(
                      programsList[index].programName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Text(
                      programsList[index].programDuration + " Days",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: Image.network(
                  allUrl[index],
                  fit: BoxFit.cover,
                ),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
