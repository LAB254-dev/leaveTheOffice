import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/provider.dart';

class Staff_info {
  // 기본 정보
  int id;
  String name;
  String roll;

  // DB
  static const String memTableName = "members";  //table name
  static const String columnId = "id";           //primary key
  static const String columnName = "name";
  static const String columnRole = "role";

  // 시간 계산
  Attendance _attendance;
  int startTimeSec;
  Timer timer;
  int workState; // 0: before, 1: ing, 2: after

  Staff_info(String name, String role, {int id}) {
    this.name = name;
    this.roll = role;
    this.id = id;
  }

  // DB
  void setStartTime(Time time, bool isSaved){
    // 근무 시작 시간 저장
    DateTime now = DateTime.now();
    startTimeSec = time.hour * 3600 + time.min * 60 + time.sec;
    _attendance = new Attendance(id, Date(now.year, now.month, now.day), time);
    workState = 1;
    if(!isSaved)  // 데이터베이스에 저장
      getDataManager().addAttData(_attendance);
  }

  void setEndTime(DateTime now){
    // 근무 종료 시간 저장
    _attendance.end = Time(now.hour, now.minute, now.second);
    // 데이터베이스에 저장
    getDataManager().updateAttData(_attendance, id, _attendance.date);
  }

  // Timer
  void startTimer(Timer timer){
    this.timer = timer;
  }

  void endTimer(){
    this.timer?.cancel();
  }

  void setAttendance(Attendance attendance){
    workState = 0;
    if(attendance != null) {
      _attendance = attendance;
      setStartTime(attendance.start, true);
      if (attendance.end == null) {
        workState = 1;
      }
      else {
        workState = 2;
      }
    }
  }
}
