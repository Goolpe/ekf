import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static const _databaseName = "EkfDB.db";
  static const _databaseVersion = 1;
  static const createTablesQueries = [
    r'''CREATE TABLE IF NOT EXISTS Employee (
      id INTEGER PRIMARY KEY autoincrement,
      surname TEXT,
      name TEXT,
      patronymic TEXT,
      position TEXT,
      dateOfBirth TEXT,
      amountOfChildren INTEGER
    )''',
    r'''CREATE TABLE IF NOT EXISTS Child (
      id INTEGER PRIMARY KEY autoincrement,
      parentID INTEGER,
      surname TEXT,
      name TEXT,
      patronymic TEXT,
      dateOfBirth TEXT
    )'''
  ];

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    return _database != null
    ? _database
    : await initDB();
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path, 
      version: _databaseVersion, 
      onCreate: _onCreate
    );
  }

  _onCreate(Database db, int version){
    createTablesQueries.forEach((element) async{
      await db.execute(element);
    });
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    Database db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> getByID(String table, int id) async {
    Database db = await database;
    return await db.query(table, where: 'parentID = ?', whereArgs: [id]);
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[0];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, String columnName, int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnName = ?', whereArgs: [id]);
  }
}