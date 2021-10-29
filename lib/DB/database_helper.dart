import 'dart:io' show Directory;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseHelper {
  static final _databaseName = "BabyDatabase.db";
  static final _databaseVersion = 1;
  static final table = "babies_info";
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnIconFileName = 'icon_file_name';
  static final columnIconBackgroundColor = 'icon_background_color';
  static final columnBirthday = 'birthday';

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
        version: _databaseVersion, onCreate: _onCreate);
  }

  //SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnIconFileName TEXT NOT NULL,
      $columnIconBackgroundColor INTEGER NOT NULL,
      $columnBirthday TEXT NOT NULL
    )''');
  }
}
