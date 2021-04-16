import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leavetheoffice/provider.dart';

import '../data/staff_info_data.dart';

class Staff extends StatefulWidget {
  int index;

  Staff(int index, String name, String roll) {
    this.index = index;
  }

  @override
  State createState() => _StaffState(index);
}

class _StaffState extends State<Staff> {
  // Constants
  static const List<String> buttonTexts = ["출근하기", "퇴근하기"];
  static const String beforeWork = "출근 전";

  // Staff info정
  int index;
  Staff_info info;

  // Component variables
  String timeMessage = beforeWork;
  String buttonMessage = buttonTexts[0];

  _StaffState(int index) {
    this.index = index;
    info = getDataManager().getStaffInfo(index);
  }

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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Colors.lightBlue.shade600,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 140,
                    vertical: 15,
                  ),
                ),
                child: Text(buttonMessage),
                onPressed: _buttonClicked,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    if (info.timer != null && info.isWorking) {
      // 화면에 그려지지 않아 삭제된 컴포넌트인 경우, 타이머를 다시 시작
      buttonMessage = buttonTexts[1];
      _updateWorkHours();
      _setTimer();
      setState(() {});
    }
  }

  @override
  void dispose() {
    info.endTimer();
    super.dispose();
  }

  void _buttonClicked() {
    if (!info.isWorking) {
      //click when start working
      // update data
      info.switchIsWorking();
      info.setStartTime(DateTime.now());
      //update text component
      buttonMessage = buttonTexts[1];

      _setTimer();
      _updateWorkHours();
    } else {
      //click during working
      showDialog(
          context: context,
          builder: (context) {
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
                      // update data
                      info.switchIsWorking();
                      info.setEndTime(DateTime.now());
                      // update text components
                      timeMessage = beforeWork;
                      buttonMessage = buttonTexts[0];

                      info.endTimer();
                      setState(() {});

                      Navigator.pop(context);
                    },
                    child: Text("확인")),
              ],
            );
          });
    }
  }

  void _updateWorkHours() {
    // 시간 갱신 및 화면 새로고침
    DateTime now = DateTime.now();
    int nowSec = now.hour * 360 + now.minute * 60 + now.second;
    timeMessage =
        "${((nowSec - info.startTimeSec) / 60).floor()}시간 ${(nowSec - info.startTimeSec) % 60}분";

    setState(() {});
  }

  void _setTimer() {
    // 타이머 설
    info.startTimer(new Timer.periodic(Duration(seconds: 1), (t) {
      _updateWorkHours();
    }));
  }
}
