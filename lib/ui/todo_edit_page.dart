import 'package:flutter/material.dart';
import 'package:flutter_todo_demo/data/db/todo_dao.dart';
import 'package:flutter_todo_demo/data/model/todo.dart';

class TodoEditPage extends StatefulWidget {
  @override
  _TodoEditPageState createState() => new _TodoEditPageState();
}

class _TodoEditPageState extends State<TodoEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _clickable = false;

  void _verifyTitle() {
    final String title = _titleController.text;
    if (title.isEmpty) {
      _clickable = false;
    }
    if (_clickable != title.isNotEmpty) {
      setState(() {
        _clickable = title.isNotEmpty;
      });
    }
  }

  @override
  void initState() {
    _titleController?.addListener(_verifyTitle);
    super.initState();
  }

  @override
  void dispose() {
    _titleController?.removeListener(_verifyTitle);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Edit'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: '请输入标题',
                border: InputBorder.none,
                //hintStyle: TextStyles.textGrayC14
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '请输入备注',
                border: InputBorder.none,
                //hintStyle: TextStyles.textGrayC14
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              onPressed: () {
                String title = _titleController.text;
                String content = _contentController.text;
                TodoDao().insertOrUpdate(Todo.fromMap(<String, String>{
                  columnId: null,
                  columnTitle: title,
                  columnContent: content,
                  columnStatus: "0"
                }));
                Navigator.of(context).pop(0);
              },
              textColor: Colors.white,
              color: Color(0xFF26A2FF),
              disabledTextColor: Color(0xFFD4E2FA),
              disabledColor: Color(0xFF7DC7FF),
              child: Container(
                height: 48,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  '确定',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
