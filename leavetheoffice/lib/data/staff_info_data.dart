import 'dart:async';

import 'package:leavetheoffice/data/attendance.dart';

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
  DateTime _workStartTime, _workEndTime;

  // 시간 계산
  Attendance _att;
  int startTimeSec;
  Timer timer;
  bool isWorking;

  Staff_info(String name, String role, {int id}) {
    this.name = name;
    this.roll = role;
    this.isWorking = false;   // 출근시간이 NOT NULL이고 퇴근시간이 NULL
                              // (_workStartTime != null && _workEndTime == null)일 때 TRUE
  }

  void switchIsWorking(){
    this.isWorking = !this.isWorking;
  }

  // DB
  void setStartTime(DateTime time){
    _workStartTime = time;
    startTimeSec = time.hour * 360 + time.minute * 60 + time.second;
  }

  void setEndTime(DateTime time){
    _workEndTime = time;
  }

  // Timer
  void startTimer(Timer timer){
    this.timer = timer;
  }

  void endTimer(){
    this.timer?.cancel();
  }
}
