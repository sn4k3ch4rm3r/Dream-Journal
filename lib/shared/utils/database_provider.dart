// ignore_for_file: constant_identifier_names

import 'package:dream_journal/shared/models/dream.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String TABLE_DREAM = 'dream';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_DATE = 'date';
  static const String COLUMN_DREAM = 'content';
  static const String COLUMN_ISLUCID = 'lucid';
  static const String COLUMN_ISNIGHTMARE = 'nightmare';
  static const String COLUMN_ISRECURRENT = 'recurrent';
  static const String COLUMN_SLEEPPARALYSIS = 'sleepparalysis';
  static const String COLUMN_FALSEAWAKENING = 'falseawakening';
  static const String COLUMN_VIVIDITY = 'vividity';
  static const String COLUMN_LUCIDITY = 'lucidity';

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database? _database;

  Future<void> _onCreate(Database db) async {
    await db.execute('CREATE TABLE $TABLE_DREAM ('
        '$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$COLUMN_DATE TEXT,'
        '$COLUMN_DREAM TEXT,'
        '$COLUMN_ISLUCID INTEGER,'
        '$COLUMN_ISNIGHTMARE INTEGER,'
        '$COLUMN_ISRECURRENT INTEGER,'
        '$COLUMN_SLEEPPARALYSIS INTEGER,'
        '$COLUMN_FALSEAWAKENING INTEGER,'
        '$COLUMN_VIVIDITY INTEGER,'
        '$COLUMN_LUCIDITY INTEGER'
        ');');
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createDatabase();
      return _database!;
    }
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'dreams.db'),
      version: 2,
      onCreate: (db, version) async {
        await _onCreate(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE $TABLE_DREAM');
        await _onCreate(db);
      },
    );
  }

  Future<List<Dream>> getDreams() async {
    final db = await database;
    var dreams = await db.query(TABLE_DREAM);

    List<Dream> dreamList = [];
    for (var dream in dreams) {
      dreamList.add(Dream.fromMap(dream));
    }
    return dreamList;
  }

  Future<Dream> insert(Dream dream) async {
    final db = await database;
    dream.id = await db.insert(TABLE_DREAM, dream.toMap());
    return dream;
  }

  Future<void> update(Dream dream) async {
    final db = await database;
    db.update(TABLE_DREAM, dream.toMap(), where: '$COLUMN_ID = ?', whereArgs: [
      dream.id
    ]);
  }

  Future<void> delete(Dream dream) async {
    final db = await database;
    db.delete(TABLE_DREAM, where: '$COLUMN_ID = ?', whereArgs: [
      dream.id
    ]);
  }
}
