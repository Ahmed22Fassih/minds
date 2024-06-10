

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../pages/home/models/todo_login_response.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL
    )
    ''');
  }

  Future<void> insertUser(Todos user) async {
    final db = await instance.database;
    await db.insert('users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Todos>> getUsers() async {
    final db = await instance.database;

    final result = await db.query('todos');

    return result.map((json) => Todos.fromJson(json)).toList();
  }

  Future<void> deleteAllUsers() async {
    final db = await instance.database;
    await db.delete('todos');
  }
}
