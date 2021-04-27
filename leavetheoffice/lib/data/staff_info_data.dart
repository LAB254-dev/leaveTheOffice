import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/provider.dart';

enum WorkState {
  beforeWork, working, afterWork
}

class Staff_info {
  // 기본 정보
  int id;
  String name;
  String role;

  // DB
  static const String memTableName = "members";  //table name
  static const String columnId = "id";           //primary key
  static const String columnName = "name";
  static const String columnRole = "role";

  // 시간 계산
  Attendance attendance;
  int startTimeSec;
  Timer timer;
  WorkState workState;

  Staff_info(String name, String role, {int id}) {
    this.name = name;
    this.role = role;
    this.id = id;
  }

  // DB
  void setStartTime(Time time, bool isSaved){
    // 근무 시작 시간 저장
    DateTime now = DateTime.now();
    startTimeSec = time.hour * 3600 + time.min * 60 + time.sec;
    attendance = new Attendance(id, Date(now.year, now.month, now.day), time);
    workState = WorkState.working;
    if(!isSaved)  // 데이터베이스에 저장
      getDataManager().addAttData(attendance);
  }

  void setEndTime(DateTime now){
    // 근무 종료 시간 저장
    attendance.end = Time(now.hour, now.minute, now.second);
    // 데이터베이스에 저장
    getDataManager().updateAttData(attendance, id, attendance.date);
  }

  // Timer
  void startTimer(Timer timer){
    this.timer = timer;
  }

  void endTimer(){
    this.timer?.cancel();
  }

  void setAttendance(Attendance att){
    // 기존 근태 기록이 있는 경우 근태 기록을 저장하고, 근무 상태를 판단
    attendance = att;
    workState = WorkState.beforeWork;
    if(att != null) {
      setStartTime(att.start, true);
      if (att.end == null) {
        workState = WorkState.working;
      }
      else {
        workState = WorkState.afterWork;
      }
    }
  }
}
