

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyGoals{

  //List<String> _weekdays = ['notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted'];
  List<String> _weekdays;
  String _firstDayOfTheWeek;

  static WeeklyGoals _instance;

  WeeklyGoals(){
    init();
    /*_getWeeklyData();
    _resetWeeklyData();*/
  }

  init() async {
    await _getWeeklyData();
    await _resetWeeklyData();
  }

  WeeklyGoals getInstance(){
   if(_instance == null){
     _instance = new WeeklyGoals();
   }

   return _instance;
  }

  Future<void> _getWeeklyData() async {
    final preferences = await SharedPreferences.getInstance();

    _weekdays = preferences.getStringList('weekdays')
        ?? ['notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted'];

    DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    String firstWeekday = DateFormat('M-d').format(firstDayOfWeek).toString();
    _firstDayOfTheWeek = preferences.getString('firstDayOfTheWeek') ?? firstWeekday;
  }

  Future<void> saveWeeklyData() async {
    final preferences = await SharedPreferences.getInstance();

    DateTime date = DateTime.now();
    _weekdays[date.weekday - 1] = 'completed';
    preferences.setStringList('weekdays', _weekdays);
    print(_weekdays);
    print(_firstDayOfTheWeek);
  }

  Future<void> _resetWeeklyData() async {
    final preferences = await SharedPreferences.getInstance();

    DateTime today = DateTime.now();
    DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    String firstWeekday = DateFormat('M-d').format(firstDayOfWeek).toString();

    if(_firstDayOfTheWeek != firstWeekday){
      //reset
      _weekdays = ['notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted', 'notCompleted'];
      preferences.setStringList('weekdays', _weekdays);
      _firstDayOfTheWeek = firstWeekday;
      preferences.setString('firstDayOfTheWeek', _firstDayOfTheWeek);
    }
  }

  String get firstDayOfTheWeek => _firstDayOfTheWeek;

  set firstDayOfTheWeek(String value) {
    _firstDayOfTheWeek = value;
  }

  List<String> get weekdays => _weekdays;

  set weekdays(List<String> value) {
    _weekdays = value;
  }
}