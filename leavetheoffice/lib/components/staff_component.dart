import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/custom_button.dart';
import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/provider.dart';

import '../data/staff_info_data.dart';

class Staff extends StatefulWidget {
  Staff_info info;
  List<Attendance> todayAttendance;

  Staff(this.info, this.todayAttendance);

  @override
  State createState() => _StaffState(info, todayAttendance);
}

class _StaffState extends State<Staff> {
  // Constants
  static const int standartHourPerSecond = 10;

  // Staff info
  Staff_info info;
  List<Attendance> todayAttendance;
  int remainSecond = -1;

  // Component variables
  String timeMessage = "";
  String buttonMessage = "";

  _StaffState(this.info, this.todayAttendance);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.shade600.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 55,
            child: Center(
              child: Text(
                '환영합니다. ❤ ${info.roll != null ? info.roll : "담당 로딩 실패.."}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 70,
            child: Center(
              child: Text(
                info.name != null ? info.name : "이름 로딩 실패..",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Colors.yellow.shade700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 50,
            child: Center(
              child: Text(
                timeMessage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFFE05764),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 75,
            child: Center(
              child: CustomButton(
                  buttonMessage, info.workState == 2 ? null : _buttonClicked),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _setInitWork();

    if (info.timer != null && info.workState == 1) {
      // 애플리케이션이 중단되진 않았으나 화면에 그려지지 않아 삭제된 컴포넌트인 경우, 타이머를 다시 시작
      _setStartWork();
    }

    // 애플리케이션이 중간에 중단되었다가 재시동된 경우 판단
    for (int i = 0; i < todayAttendance.length; i++) {
      if (todayAttendance[i].id == info.id) {
        info.setAttendance(todayAttendance[i]);
        debugPrint(todayAttendance[i].end.toString());
        if (info.workState == 1) {
          _setStartWork();
        } else if (info.workState == 2) {
          _setEndWork();
        }
      }
    }
  }

  @override
  void dispose() {
    info.endTimer();
    super.dispose();
  }

  void _buttonClicked() {
    if (info.workState == 0) {
      //click when start working
      DateTime now = DateTime.now();
      _setStartWork();
      info.setStartTime(Time(now.hour, now.minute, now.second), false,
          date: Date(now.year, now.month, now.day));
    } else {
      //click during working
      showDialog(
          context: context,
          builder: (context) {
            return _endWorkAlertDialog();
          });
    }
  }

  void _calculRemainSecond() {
    DateTime now = DateTime.now();
    int nowSec = now.hour * 3600 + now.minute * 60 + now.second;
    if (info.workState == 1)
      remainSecond = standartHourPerSecond - (nowSec - info.startTimeSec);
    else
      remainSecond = standartHourPerSecond;
  }

  void _updateWorkHours() {
    // 시간 갱신 및 화면 새로고침
    _calculRemainSecond();
    timeMessage = "";

    if (remainSecond > 0) {
      int hour = (remainSecond / 3600).floor();
      int min = ((remainSecond % 3600) / 60).floor();
      if (hour > 0) timeMessage += "$hour시간 ";
      if (min > 0) timeMessage += "$min분";
      if (remainSecond < 60) timeMessage = "$remainSecond초";
    } else if (remainSecond == 0) {
      getPageManager().pushPageArgs(context, info);
    }

    setState(() {});
  }

  void _setInitWork() {
    _calculRemainSecond();
    timeMessage = "출근 전";
    buttonMessage = "출근하기";
    info.workState = 0;
  }

  void _setStartWork() {
    info.workState = 1;
    buttonMessage = "퇴근하기";
    debugPrint(remainSecond.toString());
    info.startTimer(new Timer.periodic(Duration(seconds: 1), (t) {
      _updateWorkHours();
      if (remainSecond < 0 && info.workState == 1) timeMessage = "퇴근하세요!";
      if (info.workState == 2) {
        _setEndWork();
        info.setEndTime(DateTime.now());
        info.endTimer();
      }
    }));
  }

  void _setEndWork() {
    timeMessage = "퇴근함";
    buttonMessage = "퇴근하기";
    info.workState = 2;
    setState(() {});
  }

  Widget _endWorkAlertDialog() {
    return AlertDialog(
      title: Text("퇴근하기"),
      content: Text("퇴근하시겠습니까?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("취소")),
        ElevatedButton(
            onPressed: () {
              _setEndWork();
              Navigator.pop(context);
            },
            child: Text("확인")),
      ],
    );
  }
}
