import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/data/db/todo_dao.dart';
import 'package:flutter_todo_demo/data/model/todo.dart';
import 'package:flutter_todo_demo/data/sql_manager.dart';
import 'package:flutter_todo_demo/ui/todo_edit_page.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => new _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todoList;

  Future query() async {
    List<Todo> queryAll = await TodoDao().queryAll();
    print(queryAll.toString());
    setState(() {
      if (queryAll != null) {
        todoList = queryAll;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    query();
  }

  @override
  void dispose() {
    super.dispose();
    SqlManager.getInstance().close();
  }

  Widget _todoItem(Todo _todoItem) {
    return Container(
      height: 72,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _todoItem.title,
                style: TextStyle(fontSize: 21, color: Colors.black54),
              ),
              Text(
                _todoItem.content,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: (todoList == null) ? 0 : todoList.length,
        itemBuilder: (context, index) {
          Todo item = todoList[index];
          return _todoItem(Todo.fromMap(<String, String>{
            columnTitle: item.title,
            columnContent: item.content,
            columnStatus: item.status
          }));
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        TodoEditPage()))
                .then((value) {
              if (value == 0) {
                query();
              }
            });
          },
          child: Icon(Icons.add)),
    );
  }
}
