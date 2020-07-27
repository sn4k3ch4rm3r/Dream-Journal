import 'dart:ffi';

import 'package:dream_journal/models/dream.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String TABLE_DREAM = 'dream';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_DATE = 'date';
  static const String COLUMN_DREAM = 'content';
  static const String COLUMN_ISLUCID = 'lucid';
  static const String COLUMN_VIVIDITY = 'vividity';

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if(_database != null)
      return _database;
    else {
      _database = await createDatabase();
      return _database;
    }
  }
  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'dreams.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE $TABLE_DREAM ('
            '$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$COLUMN_DATE TEXT,'
            '$COLUMN_DREAM TEXT,'
            '$COLUMN_ISLUCID INTEGER,'
            '$COLUMN_VIVIDITY INTEGER'
          ');'
        );
      },
    );
  }

  Future<List<Dream>> getDreams() async {
    final db = await database;
    var dreams = await db.query(
      TABLE_DREAM
    );

    List<Dream> dreamList = List<Dream>();
    dreams.forEach((dream) {
      dreamList.add(Dream.fromMap(dream));
    });
    return dreamList;
  }

  Future<Dream> insert(Dream dream) async {
    final db = await database;
    dream.id = await db.insert(TABLE_DREAM, dream.toMap());
    return dream;
  }
  
  Future<void> update(Dream dream) async {
    final db = await database;
    db.update(TABLE_DREAM, dream.toMap(), where: '$COLUMN_ID = ?', whereArgs: [dream.id]);
  }
  Future<void> delete(Dream dream) async {
    final db = await database;
    db.delete(TABLE_DREAM, where: '$COLUMN_ID = ?', whereArgs: [dream.id]);
  }
}