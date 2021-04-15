import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Staff extends StatefulWidget {
  String name;
  String roll;

  Staff(String name, String roll) {
    this.name = name;
    this.roll = roll;
  }

  @override
  State createState() => _StaffState(name, roll);
}

class _StaffState extends State<Staff> {
  // Constants
  static const List<String> buttonTexts = ["출근하기", "퇴근하기"];
  static const String beforeWork = "출근 전";

  // Staff info
  String name;
  String roll;

  // Time management
  Timer _timer;
  bool isWorking = false;
  int workMin = 0;

  // DB
  DateTime workStartTime;
  DateTime workEndTime;

  // Component variables
  String timeMessage = beforeWork;
  String buttonMessage = buttonTexts[0];

  _StaffState(String name, String roll) {
    this.name = name;
    this.roll = roll;
    this.isWorking = false;
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
                '환영합니다. ❤ ${roll != null ? roll : "담당 로딩 실패.."}',
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
                name != null ? name : "이름 로딩 실패..",
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

  void _buttonClicked() {
    debugPrint("clicked");
    //click when start working
    if (!isWorking) {
      isWorking = true;

      workStartTime = DateTime.now();
      _updateWorkHours();
      buttonMessage = buttonTexts[1];

      _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        _updateWorkHours();
      });

      //click during working
    } else {
      isWorking = false;
      //show dialog
      buttonMessage = buttonTexts[0];
      _timer?.cancel();
    }

    setState(() {
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateWorkHours() {
    debugPrint("$name, $workMin");
    setState(() {
      timeMessage = "${(workMin / 60).floor()}시간 ${workMin % 60}분";
    });
    workMin++;
  }
}
