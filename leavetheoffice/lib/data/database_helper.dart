import 'package:flutter/material.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/data/music_data.dart';
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
    // 데이터베이스 초기 설정
    String dbPath = join(await getDatabasesPath(), _dbName);
    return openDatabase(dbPath, version: _version,
        onCreate: (db, version) async {
      // 스탭 정보를 저장하는 테이블 생성 쿼리
      String createMemTable = '''
          CREATE TABLE ${Staff_info.memTableName}(
            ${Staff_info.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Staff_info.columnName} TEXT NOT NULL,
            ${Staff_info.columnRole} TEXT NOT NULL,
            ${Staff_info.columnMusicId} INTEGER,
            CONSTRAINT musicId_fk FOREIGN KEY(${Staff_info.columnMusicId})
            REFERENCES ${MusicData.musicDataTableName}(${MusicData.musicDataId})
          );
      ''';
      //근태 기록을 저장하는 테이블 생성 쿼리
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
      String createMusicDataTable = '''
        CREATE TABLE ${MusicData.musicDataTableName}(
          ${MusicData.musicDataId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${MusicData.musicDataTitle} TEXT,
          ${MusicData.musicDataArtist} TEXT,
          ${MusicData.musicDataRoot} TEXT
        );
      ''';
      await db.execute(createMusicDataTable);
      await db.execute(createMemTable);
      await db.execute(createAttTable);
    });
  }

  Map<String, dynamic> memToRow(Staff_info info) {
    // Staff_info 클래스를 row 형식으로 바꿈
    return {
      Staff_info.columnName: info.name,
      Staff_info.columnRole: info.role,
      Staff_info.columnMusicId: info.musicId
    };
  }

  Staff_info rowToMem(Map<String, dynamic> row) {
    // row 형식 데이터를 Staff_info 형식으로 바꿈
    return Staff_info(row[Staff_info.columnName], row[Staff_info.columnRole],
        row[Staff_info.columnMusicId],
        id: row[Staff_info.columnId]);
  }

  Map<String, dynamic> musicToRow(MusicData data) {
    // MusicData 클래스를 row 형식으로 바꿈
    return {
      MusicData.musicDataId: data.id,
      MusicData.musicDataTitle: data.title,
      MusicData.musicDataArtist: data.artist,
      MusicData.musicDataRoot: data.root
    };
  }

  MusicData rowToMusic(Map<String, dynamic> row) {
    // row 형식 데이터를 Staff_info 형식으로 바꿈
    return MusicData(row[MusicData.musicDataTitle],
        row[MusicData.musicDataArtist],
        row[MusicData.musicDataRoot],
        id: row[MusicData.musicDataId]);
  }

  Map<String, dynamic> attToRow(Attendance att) {
    // Attendance 형식 데이터를 row 형식 데이터로 바꿈
    return {
      Attendance.columnId: att.id,
      Attendance.columnDate: att.date.toString(),
      Attendance.columnStart: att.start.toString(),
      Attendance.columnEnd: att.end.toString(),
    };
  }

  Attendance rowToAtt(Map<String, dynamic> row, {bool joinedTable = false}) {
    // row 형식 데이터를 Attendance 형식 데이터로 바꿈
    if (row[Attendance.columnDate] == null) {
      return null;
    }
    List<String> date = row[Attendance.columnDate].split("-");
    List<int> dateInt = date.map((e) => int.parse(e)).toList();
    List<String> start = row[Attendance.columnStart].toString().split(":");
    List<int> startInt = start.map((e) => int.parse(e)).toList();
    List<int> endInt;
    if (row[Attendance.columnEnd] != "null") {
      List<String> end = row[Attendance.columnEnd].toString().split(":");
      endInt = end.map((e) => int.parse(e)).toList();
    } else {
      endInt = null;
    }
    if (joinedTable) {
      return new Attendance(
          row[Staff_info.columnId],
          Date(dateInt[0], dateInt[1], dateInt[2]),
          Time(startInt[0], startInt[1], startInt[2]),
          end: endInt == null ? null : Time(endInt[0], endInt[1], endInt[2]));
    }
    return new Attendance(
        row[Attendance.columnId],
        Date(dateInt[0], dateInt[1], dateInt[2]),
        Time(startInt[0], startInt[1], startInt[2]),
        end: endInt == null ? null : Time(endInt[0], endInt[1], endInt[2]));
  }

  Staff_info rowToStaffInfoWithAtt(Map<String, dynamic> row) {
    Attendance att = rowToAtt(row, joinedTable: true);
    Staff_info info = rowToMem(row);
    info.setAttendance(att);
    return info;
  }
}
