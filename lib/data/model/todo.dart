import 'package:flutter_todo_demo/data/db/todo_dao.dart';

class Todo {
  int id;
  String title;
  String content;
  String status;

  Todo();

  Todo.fromMap(Map map) {
    id = map[columnId] as int;
    title = map[columnTitle] as String;
    content = map[columnContent] as String;
    status = map[columnStatus] as String;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnContent: content,
      columnStatus: status
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
