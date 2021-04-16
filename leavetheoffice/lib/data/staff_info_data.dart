import 'dart:async';

class Staff_info {
  String name;
  String roll;

  DateTime _workStartTime, _workEndTime;
  int startTimeSec;
  Timer timer;
  bool isWorking;

  Staff_info(name, roll) {
    this.name = name;
    this.roll = roll;
    this.isWorking = false;
  }

  void switchIsWorking(){
    this.isWorking = !this.isWorking;
  }

  void setStartTime(DateTime time){
    _workStartTime = time;
    startTimeSec = time.hour * 360 + time.minute * 60 + time.second;
  }

  void setEndTime(DateTime time){
    _workEndTime = time;
  }
}
