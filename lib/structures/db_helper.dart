import 'package:myfitnessfire/models/exo_model.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/program_days_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  static Database _database;
  static DatabaseHelper _databaseHelper; //SINGLETON DBHELPER
  DatabaseHelper._createInstance(); //NAMED CONST TO CREATE INSTANCE OF THE DBHELPER

  String programsTable = 'Programs';
  String colProgramId = 'programId';
  String colProgramName = 'programName';
  String colSellerName = 'sellerName';
  String colPrice = 'price';
  String colProgramDuration = 'programDuration';
  String colStorage = 'storage';


  String daysTable = 'Days';
  String colDayId = 'dayId';
  String colDayNumber = 'dayNumber';
  String colDayName = 'dayName';


  String exoTable = 'Exos';
  String colExoNumber = 'exoNumber';
  String colExoName = 'exoName';
  String colReps = 'reps';
  String colIsCompleted = 'isCompleted';


  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper =
          DatabaseHelper._createInstance(); //EXEC ONLY ONCE (SINGLETON OBJ)
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //GET THE PATH TO THE DIRECTORY FOR IOS AND ANDROID TO STORE DB
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'myfitnessfire.db');

    /*Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "note.db";*/

    //OPEN/CREATE THE DB AT A GIVEN PATH
    var database = await openDatabase(dbPath, version: 1, onCreate: _createDb);
    return database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $programsTable('
            '$colProgramId INTEGER PRIMARY KEY,'
            '$colProgramName TEXT,'
            '$colSellerName TEXT,'
            '$colPrice TEXT,'
            '$colProgramDuration TEXT'
            '$colStorage TEXT'
            ')');

    await db.execute(
        'CREATE TABLE $daysTable('
            '$colDayId INTEGER PRIMARY KEY,'
            '$colDayName TEXT,'
            '$colDayNumber TEXT,'
            '$colProgramId TEXT,'
            'FOREIGN KEY($colProgramId) REFERENCES $programsTable($colProgramId) ON DELETE CASCADE'
            ')');

    await db.execute(
        'CREATE TABLE $exoTable('
            '$colExoNumber INTEGER PRIMARY KEY,'
            '$colExoName TEXT,'
            '$colReps TEXT,'
            '$colIsCompleted TEXT,'
            '$colDayId TEXT,'
            'FOREIGN KEY($colDayId) REFERENCES $daysTable($colDayId) ON DELETE CASCADE'
            ')');
  }

  // GET A LIST OF PROGRAMS
  Future<List<NewProgramModel>> getProgramList() async {
    Database db = await this.database;
    List<NewProgramModel> programList = [];
    List<Map<String, dynamic>> result = await db.query(programsTable);
    result.forEach((element) {
      programList.add(NewProgramModel().fromMap(element));
    });

    return programList;
  }

  // GET A PROGRAM
  Future<NewProgramModel> getProgram(String programId) async {
    Database db = await this.database;
    NewProgramModel program;
    List<Map<String, dynamic>> result = await db.query(
        programsTable,
        where: "$colProgramId = ?",
        whereArgs: [programId]
    );
    program = NewProgramModel().fromMap(result[0]);

    return program;
  }

  // INSERT A PROGRAM
  Future<int> insertProgram(NewProgramModel program) async
  {
    Database db = await this.database;
    var result = await db.insert(programsTable, NewProgramModel().toMap(program));
    return result;
  }

  //UPDATE A PROGRAM
  Future<int> updateProgram(NewProgramModel program) async
  {
    var db = await this.database;
    var result =
    await db.update(programsTable, NewProgramModel().toMap(program), where: '$colProgramId = ?', whereArgs: [program.programId]);
    return result;
  }

  //DELETE A PROGRAM
  Future<int> deleteProgram(String programId) async
  {
    var db = await this.database;
    int result = await db.delete(programsTable, where:"$colProgramId = ?", whereArgs: [programId]);
    return result;
  }

  //GET THE NUMBER OF PROGRAMS
  Future<int> getProgramCount() async
  {
    Database db = await this.database;
    List<Map<String, dynamic>> programs = await db.rawQuery("SELECT COUNT (*) FROM $programsTable");
    int result = Sqflite.firstIntValue(programs);
    return result;
  }

  // GET A LIST OF DAYS
  Future<List<ProgramDaysModel>> getDayList() async {
    Database db = await this.database;
    List<ProgramDaysModel> dayList = [];
    List<Map<String, dynamic>> result = await db.query(daysTable);
    result.forEach((element) {
      dayList.add(ProgramDaysModel().fromMap(element));
    });

    return dayList;
  }

  // GET A DAY
  Future<ProgramDaysModel> getDay(String dayId) async {
    Database db = await this.database;
    ProgramDaysModel day;
    List<Map<String, dynamic>> result = await db.query(
        daysTable,
        where: "$colDayId = ?",
        whereArgs: [dayId]
    );
    day = ProgramDaysModel().fromMap(result[0]);

    return day;
  }

  // INSERT A DAY
  Future<int> insertDay(ProgramDaysModel day) async
  {
    Database db = await this.database;
    var result = await db.insert(daysTable, ProgramDaysModel().toMap(day));
    return result;
  }

  //UPDATE A DAY
  Future<int> updateDay(ProgramDaysModel day) async
  {
    var db = await this.database;
    var result =
    await db.update(daysTable, ProgramDaysModel().toMap(day), where: '$colDayId = ?', whereArgs: [day.dayId]);
    return result;
  }

  //DELETE A DAY
  Future<int> deleteDay(String dayId) async
  {
    var db = await this.database;
    int result = await db.delete(daysTable, where:"$colDayId = ?", whereArgs: [dayId]);
    return result;
  }

  //GET THE NUMBER OF DAYS
  Future<int> getDayCount() async
  {
    Database db = await this.database;
    List<Map<String, dynamic>> days = await db.rawQuery("SELECT COUNT (*) FROM $daysTable");
    int result = Sqflite.firstIntValue(days);
    return result;
  }

  // GET A LIST OF EXOS
  Future<List<ExoModel>> getExoList() async {
    Database db = await this.database;
    List<ExoModel> exoList = [];
    List<Map<String, dynamic>> result = await db.query(exoTable);
    result.forEach((element) {
      exoList.add(ExoModel().fromMap(element));
    });

    return exoList;
  }

  /*// GET A EXO
  Future<ExoModel> getExo(String exoId) async {
    Database db = await this.database;
    ExoModel exo;
    List<Map<String, dynamic>> result = await db.query(
        exoTable,
        where: "$colProgramId = ?",
        whereArgs: [programId]
    );
    program = NewProgramModel().fromMap(result[0]);

    return program;
  }

  // INSERT A PROGRAM
  Future<int> insertProgram(NewProgramModel program) async
  {
    Database db = await this.database;
    var result = await db.insert(programsTable, NewProgramModel().toMap(program));
    return result;
  }

  //UPDATE A PROGRAM
  Future<int> updateProgram(NewProgramModel program) async
  {
    var db = await this.database;
    var result =
    await db.update(programsTable, NewProgramModel().toMap(program), where: '$colProgramId = ?', whereArgs: [program.programId]);
    return result;
  }

  //DELETE A PROGRAM
  Future<int> deleteProgram(String programId) async
  {
    var db = await this.database;
    int result = await db.delete(programsTable, where:"$colProgramId = ?", whereArgs: [programId]);
    return result;
  }

  //GET THE NUMBER OF PROGRAMS
  Future<int> getCount() async
  {
    Database db = await this.database;
    List<Map<String, dynamic>> programs = await db.rawQuery("SELECT COUNT (*) FROM $programsTable");
    int result = Sqflite.firstIntValue(programs);
    return result;
  }*/

}