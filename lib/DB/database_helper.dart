import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static const _databaseName = "BabyDatabase.db";
  static const _databaseVersion = 3;
  static const table = "babies_info";
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnIconFileName = 'icon_file_name';
  static const columnIconBackgroundColor = 'icon_background_color';
  static const columnBirthday = 'birthday';
  static const columnCountDownBirthday = 'count_down_birthday';

  //make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    //lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  //this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnIconFileName TEXT NOT NULL,
      $columnIconBackgroundColor INTEGER NOT NULL,
      $columnBirthday TEXT NOT NULL,
      $columnCountDownBirthday INTEGER NOT NULL
    )''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion){
    if(oldVersion < newVersion){
      db.execute("ALTER TABLE $table ADD COLUMN $columnCountDownBirthday INTEGER;");
    }
  }

}
