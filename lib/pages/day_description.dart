import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfitnessfire/models/exo_model.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/program_days_model.dart';
import 'package:myfitnessfire/models/weekly_goals_model.dart';
import 'package:myfitnessfire/structures/localizations.dart';
import 'package:myfitnessfire/structures/user_model.dart';
import 'package:myfitnessfire/widgets/brazier.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../words.dart';

class DayDescriptionPage extends StatefulWidget {
  static const tag = "day_description_page";

  @override
  _DayDescriptionPageState createState() => _DayDescriptionPageState();
}

class _DayDescriptionPageState extends State<DayDescriptionPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool achived = false;
  bool isShop;
  NewProgramModel currentProgram;
  ProgramDaysModel currentDay;
  List<bool> isExerciseCompleted = [];
  List<ExoModel> exoList = [];
  List<String> urls = [];
  UserModel _userInstance = UserModel().getInstance();
  WeeklyGoals weeklyGoals = WeeklyGoals().getInstance();

  //Future<void> _dayContent;

  /*Future<void> _fetchDayContent() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    await db.collection("Programs")
        .doc(currentProgram.programId)
        .collection("Content")
        .doc(currentDay.dayId)
        .collection("Exo")
        .orderBy("exoNumber")
        .get()
        .then((QuerySnapshot snapshot) => {
      snapshot.docs.forEach((doc) async {
        exoList.add(ExoModel().fromMap(doc.data()));
        print(doc.data());
      })
    });
  }*/

  @override
  Widget build(BuildContext context) {
    String translate(context, words) {
      return AppLocalizations.of(context).translate(words);
    }

    List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    String imageUrl = arguments[0];
    isShop = arguments[1];
    currentProgram = arguments[2];
    currentDay = arguments[3];
    exoList = arguments[4];

    //_dayContent = _fetchDayContent();

    final bool isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: BezierContainer(),
          ),
          CustomScrollView(
            slivers: [
              _sliverAppBar(
                imageUrl: imageUrl,
                isLight: isLight,
              ),
              _sliverAllExo(
                  isLight: isLight,
                  translate: (context, words) =>
                      translate(context, words)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sliverAppBar({
    bool isLight,
    String imageUrl,
  }) {
    return SliverAppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            _updateExo();
            Navigator.of(context).pop();
          }),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          background: Hero(
            tag: "test" + currentDay.dayNumber,
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: double.infinity,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.5/2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: [
                            0.0,
                            1.0
                          ])),
                )
              ],
            ),
          ),
        ),
      ),
      pinned: true,
      title: Text(
        currentDay.dayName,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height / 2.5 -
          MediaQuery.of(context).padding.top,
    );
  }

  Widget _sliverAllExo({
    bool isLight,
    String translate(context, words),
  }) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Column(
            children: List.generate(
              exoList.length,
                  (index) {
                List<dynamic> reps = ExoModel().getReps(exoList[index].reps) ?? [];
                String exo = exoList[index].exoName ?? "";
                bool isCompleted = exoList[index].isCompleted ?? false;
                exoList[index].isCompleted = isCompleted;
                return Container(
                  color: isLight
                      ? Color.fromRGBO(240, 240, 240, 1).withOpacity(0.2)
                      : Color.fromRGBO(40, 40, 40, 1).withOpacity(0.4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isLight
                              ? Color.fromRGBO(240, 240, 240, 1)
                              .withOpacity(0.8)
                              : Color.fromRGBO(40, 40, 40, 1).withOpacity(0.8),
                          child: Text(
                            exoList[index].exoNumber,
                            style:
                            TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                        title: Text(exo),
                        subtitle: Row(
                          children: List.generate(
                            reps.length,
                                (index) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                reps[index],
                              ),
                            ),
                          ),
                        ),
                        trailing: isShop
                            ? null
                            : IconButton(
                            icon: Icon(
                                isCompleted
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline
                            ),
                            onPressed: () {
                              setState(() {
                                exoList[index].isCompleted = !isCompleted;
                              });
                            }),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            ),
          ),
          isShop
              ? Container()
              : _bottomAppBar(translate: (context, words) => translate(context, words)),
        ],
      ),
    );
  }

  Widget _bottomAppBar({String translate(context, words)}) {
    bool completedFlag = true;
    return InkWell(
      onTap: () async {
        /*for(int i = 0; i < isExerciseCompleted.length; i++){
          if(isExerciseCompleted[i] == false) {
            completedFlag = false;
          }
        }

        if(completedFlag == true){
          WeeklyGoals weeklyGoals = WeeklyGoals().getInstance();
          weeklyGoals.saveWeeklyData();
          _saveData();
          Navigator.of(context).pop();
        }*/
        for(int i = 0; i < exoList.length; i++){
          if(!exoList[i].isCompleted)
            completedFlag = false;
        }
        if(completedFlag){
          weeklyGoals.saveWeeklyData();
          _updateExo();
        }
        else{
          print("Completed Button Pressed");
          //Scaffold.of(context).showSnackBar(new SnackBar(content: Text('Please complete all the exercises!'), duration: Duration(seconds: 2),));
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
          ),
        ),
        child: Center(
          child: Text(
            translate(context, Words.completed),
            style: TextStyle(
              color: Color.fromRGBO(240, 240, 240, 1),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  _updateExo() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    for(int j = 0 ; j < exoList.length; j++){

      await db.collection("Users")
          .doc(_userInstance.userId)
          .collection("purchased")
          .doc(currentProgram.programId)
          .collection("Content")
          .doc(currentDay.dayId)
          .collection("Exo")
          .where("exoNumber", isEqualTo: exoList[j].exoNumber)
          .get()
          .then((doc) => {
        doc.docs.forEach((document) async {
          await db.collection("Users")
              .doc(_userInstance.userId)
              .collection("purchased")
              .doc(currentProgram.programId)
              .collection("Content")
              .doc(currentDay.dayId)
              .collection("Exo")
              .doc(document.id)
              .set(ExoModel().toMap(exoList[j]), SetOptions(merge: true))
              .catchError((error) => (){
            print("Failed: $error");
            SnackBar snackbar = SnackBar(
              content: Text("Failed: $error"),
              backgroundColor: Colors.redAccent,);
            _scaffoldKey.currentState.showSnackBar(snackbar);
          });
        })
      });
    }

    SnackBar snackbar = SnackBar(
      content: Text("Saved!"),
      backgroundColor: Colors.redAccent,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
