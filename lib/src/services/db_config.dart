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

  Future<List<Map<String, dynamic>>> getAll(String table, {int parentID}) async {
    Database db = await database;
    
    return parentID != null
    ? await db.query(table, where: 'parentID = ?', whereArgs: [parentID])
    : await db.query(table);
  }

  Future<void> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    await db.insert(table, row);
  }

  Future<void> update(String table, int id, int count) async {
    Database db = await database;
    List<Map<String, dynamic>> _data = await db.query(table, where: 'id = ?', whereArgs: [id]);
    await db.update(table, {'amountOfChildren': _data[0]['amountOfChildren'] + count}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(String table, String columnName, int id) async {
    Database db = await database;
    await db.delete(table, where: '$columnName = ?', whereArgs: [id]);
  }
}