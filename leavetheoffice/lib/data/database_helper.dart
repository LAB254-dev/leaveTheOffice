import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'att_data_format.dart';

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
    return openDatabase(dbPath, version: _version,
        onCreate: (db, version) async {
      String createMemTable = '''
          CREATE TABLE ${Staff_info.memTableName}(
            ${Staff_info.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Staff_info.columnName} TEXT NOT NULL,
            ${Staff_info.columnRole} TEXT NOT NULL
          );
          ''';
      String createAttTable = '''
          CREATE TABLE ${Attendance.attTableName}(
            ${Attendance.columnId} INTEGER,
            ${Attendance.columnDate} TEXT,
            ${Attendance.columnStart} TEXT NOT NULL,
            ${Attendance.columnEnd} TEXT,
            PRIMARY KEY (${Attendance.columnId}, ${Attendance.columnDate}),
            FOREIGN KEY (${Attendance.columnId}) REFERENCES ${Staff_info.memTableName}(${Staff_info.columnId})
              ON DELETE CASCADE 
              ON UPDATE NO ACTION
          );
          ''';
      await db.execute(createMemTable);
      await db.execute(createAttTable);
    });
  }

  Map<String, dynamic> memToRow(Staff_info info) {
    return {
      Staff_info.columnName: info.name,
      Staff_info.columnRole: info.roll,
    };
  }

  Staff_info rowToMem(Map<String, dynamic> row) {
    return Staff_info(row[Staff_info.columnName], row[Staff_info.columnRole],
        id: row[Staff_info.columnId]);
  }

  Map<String, dynamic> attToRow(Attendance att) {
    return {
      Attendance.columnId: att.id,
      Attendance.columnDate: att.date.toString(),
      Attendance.columnStart: att.start.toString(),
      Attendance.columnEnd: att.end.toString(),
    };
  }

  Attendance rowToAtt(Map<String, dynamic> row) {
    List<String> date = row[Attendance.columnDate].toString().split("/");
    List<int> dateInt = date.map((e) => int.parse(e));
    List<String> start = row[Attendance.columnStart].toString().split(":");
    List<int> startInt = start.map((e) => int.parse(e));
    List<int> endInt;
    if (row[Attendance.columnEnd] != null) {
      List<String> end = row[Attendance.columnEnd].toString().split(":");
      endInt = end.map((e) => int.parse(e));
    } else {
      endInt = null;
    }
    return new Attendance(
        row[Attendance.columnId],
        Date(dateInt[0], dateInt[1], dateInt[2]),
        Time(startInt[0], startInt[1], startInt[2]),
        end: endInt == null ? null : Time(endInt[0], endInt[1], endInt[2]));
  }
}
