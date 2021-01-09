import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:diary_app/diary.dart';

final String databaseName = 'mydiary.db';
final String tableName = 'diary';

class DatabaseHelper {

  DatabaseHelper._();
  static final DatabaseHelper _db = DatabaseHelper._();
  static Database _database;

  factory DatabaseHelper() => _db;

  Future<Database> get database async {
    if (_database == null) _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, databaseName);

    return await openDatabase (
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute('''
        CREATE TABLE diary (
        id integer primary key autoincrement,
        title VARCHAR(255) not null,
        body TEXT,
        updatedAt DATETIME not null
        );
        ''');
      });
  }

  createDiary(Diary diary) async {
    final db = await database;

    var res = await db.insert(tableName, diary.toMap());
    return res;
  }

  getDiary(int id) async {
    final db = await database;
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Diary.fromMap(res.first) : Null;
  }

  Future<List<Diary>> getAllDiaries() async {
    final db = await database;

    var res = await db.query(tableName, orderBy: 'updatedAt DESC');
    List<Diary> list =
        res.isNotEmpty ? res.map((c) => Diary.fromMap(c)).toList() : [];

    return list;
  }

  updateDiary(Diary diary) async {
    final db = await database;

    var res = await db.update(tableName, diary.toMap(),
    where: 'id = ?', whereArgs: [diary.id]);

    return res;
  }

  deleteDiary(int id) async {
    final db = await database; db.delete(tableName, where: 'id = ?', whereArgs: []);
  }
}
