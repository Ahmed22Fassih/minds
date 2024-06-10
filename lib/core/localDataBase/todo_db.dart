import 'package:sqflite/sqflite.dart';

import '../../pages/home/models/todo_login_response.dart';

class TodoBD {
  static Future<Database> createDatabase() async {
    return await openDatabase("todos_db",

        /// database path
        version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE todos (id INTEGER PRIMARY KEY,todo TEXT, completed INTEGER ,userId INTEGER)');
      await db.execute(
          'CREATE TABLE saved_time (page_no INTEGER PRIMARY KEY, lastSavedTime DATETIME)');
    });
  }

  static Future insertTodo(Todos todos) async {
    var db = await createDatabase();
    return await db.insert(
        "todos",
        {
          "id": todos.id,
          "todo": todos.todo,
          "completed": todos.completed==true?1:0,
          "userId": todos.userId
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getTodos() async {
    var db = await createDatabase();
    return db.query("todos", limit: 20);
  }

  static Future<List<Map<String, dynamic>>> getMoreTodos(int lastNumber) async {
    var db = await createDatabase();
    return db.query("todos", limit: 20, offset: lastNumber);
  }

  // count the number of Todos inside database
  static Future<int?> getTodosCount() async {
    var db = await createDatabase();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM todos"));
  }

  // delete all Todos from local database
  static Future deleteAllTodos() async {
    var db = await createDatabase();
    return await db.delete("todos");
  }

  // insert time after saving to the database
  static Future insertSaveTime(int pageNo) async {
    var db = await createDatabase();
    return await db.insert("saved_time",
        {"page_no": pageNo, "lastSavedTime": DateTime.now().toString()},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //  get the saved time of each page
  static Future<List<Map<String, dynamic>>> getSaveTime() async {
    var db = await createDatabase();
    var data = await db.query("saved_time");
    return data;
  }

  // delete the saved time table
  static Future deleteSavedTime() async {
    var db = await createDatabase();
    return await db.delete("saved_time");
  }
}
