import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/program_model.dart';
import 'package:myfitnessfire/models/programs_model.dart';
import 'package:myfitnessfire/pages/shop_page.dart';
import 'package:myfitnessfire/pages/workout.dart';
import 'package:myfitnessfire/widgets/programTile.dart';

class Search extends SearchDelegate {
  bool isShop = true;
  NewProgramModel selectedResult;
  int currentIndex;
  List<NewProgramModel> suggestionList = [];
  List<NewProgramModel> recentList = [];

  List<ProductDetails> products;
  List<String> allUrl;
  List<NewProgramModel> programList;
  Search({@required this.products, @required this.allUrl, @required this.programList});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = ThemeData(primaryColor: Color(0xffe46b10));
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            recentList.add(suggestionList[index]);
            //selectedResult = suggestionList[index];
            //currentIndex = programList.indexOf(selectedResult);
            //showResults(context);

            Navigator.of(context).pushNamed(WorkoutPage.tag, arguments: [
              isShop,
              index,
              programList[index],
              products,
            ]);
          },
          child: ProgramTile()
              .programTile(size, allUrl[index], programList[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList
        : suggestionList.addAll(programList.where(
            (element) => element.sellerName.toLowerCase().contains(query.toLowerCase()),
          ));
    /*if (suggestionList.isEmpty) {
      suggestionList.addAll(programs.getRange(0, 2));
    } else {}*/

    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            recentList.add(suggestionList[index]);
            //selectedResult = suggestionList[index];
            //currentIndex = programList.indexOf(selectedResult);
            //showResults(context);

            Navigator.of(context).pushNamed(WorkoutPage.tag, arguments: [
              isShop,
              index,
              programList[index],
              products,
            ]);
          },
          child: ProgramTile()
              .programTile(MediaQuery.of(context).size, allUrl[index], programList[index]),
        );
      },
    );
  }
}
