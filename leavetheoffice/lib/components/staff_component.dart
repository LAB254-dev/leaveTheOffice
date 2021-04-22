import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/custom_button.dart';
import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/provider.dart';

import '../data/staff_info_data.dart';

class Staff extends StatefulWidget {
  Staff_info info;
  Attendance todayAttendance;

  Staff(this.info, this.todayAttendance);

  @override
  State createState() => _StaffState(info, todayAttendance);
}

class _StaffState extends State<Staff> {
  // Constants
  static const int standartHourPerSecond = 9 * 3600;

  // Staff info
  Staff_info info;
  Attendance todayAttendance;
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
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5,),
              Center(
                child: Text(
                  '환영합니다. ❤ ${info.roll != null ? info.roll : "담당 로딩 실패.."}',
                  style: TextStyle(
                    fontFamily: "NotoSans",
                    fontSize: 15,
                  ),
                ),
              ),
              Center(
                child: Text(
                  info.name != null ? info.name : "이름 로딩 실패..",
                  style: TextStyle(
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.yellow.shade700,
                  ),
                ),
              ),
              Center(
                child: Text(
                  timeMessage,
                  style: TextStyle(
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFE05764),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Center(
                child: CustomButton(
                    // 현재 근무 상태가 2(퇴근)이면 버튼 비활성화
                    buttonMessage,
                    info.workState == 2 ? null : _buttonClicked),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _setInitWork();
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
      info.setStartTime(
        Time(now.hour, now.minute, now.second),
        false,
      );
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
    // 남은 시간 계산
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

    // 출근 전인 경우
    if(info.workState == 0){
      timeMessage = "출근 전";
      buttonMessage = "출근하기";
      return;
    }

    // 근무중인 경우
    if (remainSecond > 0) {
      int hour = (remainSecond / 3600).floor();
      int min = ((remainSecond % 3600) / 60).floor();
      if (hour > 0) timeMessage += "$hour시간 ";
      if (min > 0) timeMessage += "$min분";
      if (remainSecond < 60) timeMessage = "$remainSecond초";
    } else if (remainSecond == 0) {
      getPageManager().pagePushRequest(context, info);
    }

    // 기준 근무 시간이 지났음에도 퇴근하지 않은 경우
    if (remainSecond < 0 && info.workState == 1) timeMessage = "퇴근하세요!";

    // 퇴근한 경우
    if (info.workState == 2) {
      _setEndWork();
      info.setEndTime(DateTime.now());
      info.endTimer();
    }

    setState(() {});
  }

  void _setInitWork() {
    info.workState = 0;

    // 애플리케이션이 중단되진 않았으나 화면에 그려지지 않아 삭제된 컴포넌트인 경우, 타이머를 다시 시작
    if (info.timer != null && info.workState == 1) {
      _setStartWork();
    }

    // 애플리케이션이 중간에 중단되었다가 재시동된 경우 판단
    if (todayAttendance != null) {
      info.setAttendance(todayAttendance);
      if (info.workState == 1) {
        _setStartWork();
      } else if (info.workState == 2) {
        _setEndWork();
      }
    }
    _updateWorkHours();
  }

  void _setStartWork() {
    // 근무 시작 세팅
    info.workState = 1;
    buttonMessage = "퇴근하기";
    info.startTimer(new Timer.periodic(Duration(seconds: 1), (t) {
      _updateWorkHours();
    }));
  }

  void _setEndWork() {
    // 근무 종료 세팅
    timeMessage = "퇴근함";
    buttonMessage = "퇴근하기";
    info.workState = 2;
    setState(() {});
  }

  Widget _endWorkAlertDialog() {
    // 메인 화면에서 퇴근하기 버튼을 눌렀을 때 퇴근할지 묻는 팝업
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
              info.workState = 2;
              info.setEndTime(DateTime.now());
              info.endTimer();
              _setEndWork();
              Navigator.pop(context);
            },
            child: Text("확인")),
      ],
    );
  }
}
