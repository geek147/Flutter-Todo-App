import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todolist/model/todo.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper db = DbHelper._();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      return _database = await initDatabase();
    }
  }

  Future<Database> initDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (Database db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE todo (
            id INTEGER PRIMARY KEY,
            title TEXT,
            desc TEXT,
            status INTEGER
          )
        ''');
      },
    );
  }

  Future<int?> createToDo(ToDo todo) async {
    final db = await database;
    var result = await db?.rawQuery('''
      SELECT MAX(id)+1 AS id FROM todo 
    ''');
    var item = result?.first['id'];
    todo.id = item == null ? 1 : int.parse(item.toString());
    return await db?.rawInsert(
      '''
      INSERT INTO todo (id, title, desc, status)
      VALUES (?,?,?,?) 
      ''',
      [
        todo.id,
        todo.title,
        todo.desc,
        todo.status,
      ],
    );
  }

  Future<List<ToDo>> fetchAllToDo() async {
    final db = await database;
    List<Map<String, dynamic>>? res = await db?.query('todo');
    return res!.isEmpty ? [] : res.map((e) => ToDo.fromMap(e)).toList();
  }

  Future<int?> updateToDoStatus(ToDo todo) async {
    final db = await database;
    return await db?.rawUpdate(
      '''
      UPDATE todo
      SET status = ?
      WHERE id = ?
      ''',
      [
        todo.status == 1 ? 0 : 1,
        todo.id,
      ],
    );
  }

  Future<int?> deleteSingleToDo(ToDo todo) async {
    final db = await database;
    return await db?.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [
        todo.id,
      ],
    );
  }

  Future<int?> clearTodoTable() async {
    final db = await database;
    return db?.delete('todo');
  }
}
