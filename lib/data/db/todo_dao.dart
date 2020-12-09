import 'package:flutter_todo_demo/data/model/todo.dart';
import 'package:sqflite/sqflite.dart';

import '../sql_manager.dart';

/// `todo` table name
final String tableTodo = 'todo';

/// id column name
final String columnId = '_id';

/// title column name
final String columnTitle = 'title';

/// content column name
final String columnContent = 'content';

/// status column name
final String columnStatus = 'status';

class TodoDao {
  TodoDao();

  bool isTableExits = false;

  createTableSql() {
    return '''
        create table $tableTodo (
        $columnId integer primary key autoincrement,
        $columnTitle text not null,
        $columnContent text,
        $columnStatus text not null)
      ''';
  }

  getTableName() {
    return tableTodo;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  prepare(name, String createSql) async {
    isTableExits = await SqlManager.getInstance().isTableExits(name);
    if (!isTableExits) {
      Database db = await SqlManager.getInstance().getDb();
      return await db.execute(createSql);
    }
  }

  open() async {
    if (!isTableExits) {
      await prepare(getTableName(), createTableSql());
    }
    return await SqlManager.getInstance().getDb();
  }

  Future insert(Todo todo) async {
    Database db = await getDataBase();
    return await db.insert(tableTodo, todo.toMap());
  }

  Future update(Todo todo) async {
    Database db = await getDataBase();
    return await db.update(tableTodo, todo.toMap());
  }

  Future insertOrUpdate(Todo todo) async {
    if (todo?.id == null) {
      return insert(todo);
    } else {
      return update(todo);
    }
  }

  Future<List<Todo>> queryAll() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> result =
        await db.rawQuery("select * from $tableTodo");
    if (result != null) {
      List<Todo> todoList = List();
      for (Map m in result) {
        todoList.add(Todo.fromMap(m));
      }
      return todoList;
    }
    return null;
  }
}
