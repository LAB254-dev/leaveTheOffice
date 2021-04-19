import 'package:flutter/cupertino.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database _database;

  static const String _dbName = "leaveTheOffice_lab254.db";
  static const int _version = 1;

  Future<Database> getDatabase() async {
    if (_database == null) {
      _database = await _init();
    }
    return _database;
  }

  Future<Database> _init() async {
    String dbPath = join(await getDatabasesPath(), _dbName);
    return openDatabase(dbPath, version: _version, onCreate: (db, version) async {
      String sql = '''
          CREATE TABLE ${Staff_info.memTableName}(
            ${Staff_info.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Staff_info.columnName} TEXT NOT NULL,
            ${Staff_info.columnRole} TEXT NOT NULL
          );
          CREATE TABLE ${Attendance.attTableName}(
            ${Attendance.columnId} INTEGER,
            ${Attendance.columnDate} TEXT,
            ${Attendance.columnStart} TEXT,
            ${Attendance.columnEnd} TEXT,
            FOREIGN KEY (${Attendance.columnId}) REFERENCES ${Staff_info.memTableName}(${Staff_info.columnId}),
            PRIMARY KEY(${Attendance.columnId}, ${Attendance.columnDate})
          );
          INSERT INTO ${Staff_info.memTableName} (${Staff_info.columnName}, ${Staff_info.columnRole}) VALUES ('insert', 'test');
          ''';
      return db.execute(sql);
    });
  }

  Map<String, dynamic> memToRow(Staff_info info) {
    debugPrint(info.name);
    return {
      Staff_info.columnId: info.id,
      Staff_info.columnName: info.name,
      Staff_info.columnRole: info.roll,
    };
  }

  Staff_info rowToMem(Map<String, dynamic> row) {
    debugPrint(row.isNotEmpty ? "row is not empty" : "row empty");
    return Staff_info(row[Staff_info.columnName], row[Staff_info.columnRole],
        id: row[Staff_info.columnId]);
  }
}
