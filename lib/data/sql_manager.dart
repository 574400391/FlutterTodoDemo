import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlManager {
  static const TAG = "SqlManager";

  static const _NAME = "todo.db";
  static const _VERSION = 1;

  static SqlManager _instance;

  static SqlManager getInstance() {
    if (_instance == null) {
      _instance = SqlManager._();
    }
    return _instance;
  }

  SqlManager._();

  static Database _db;

  Future<void> init() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final databasePath = await getDatabasesPath();
      print("$TAG databasePath: $databasePath");
      final path = join(databasePath, _NAME);
      print("$TAG path: $path");
      if (!(await Directory(dirname(path)).exists())) {
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (e) {
          print("$TAG create db dir error: $e");
        }
      }
      _db = await openDatabase(path, version: _VERSION,
          onCreate: (Database db, int version) async {
        print("$TAG openDatabase onCreate version: $version");
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
        print(
            "$TAG openDatabase onUpgrade oldVersion: $oldVersion, newVersion: $newVersion");
      });
    } else {
      throw FlutterError('暂不支持当前平台');
    }
  }

  Future<Database> getDb() async {
    if (_db == null) {
      await init();
    }
    return _db;
  }

  isTableExits(String tableName) async {
    await getDb();
    /// Sqlite_master是Sqlite数据库内置表，返回结果为创建表的Sql。此处用于查询指定表是否已创建。
    List result = await _db.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return result.isNotEmpty;
  }

  void close() {
    _db?.close();
    _db = null;
  }
}
