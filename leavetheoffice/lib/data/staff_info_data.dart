import 'dart:async';

class Staff_info {
  // 기본 정보
  String name;
  String roll;

  DateTime _workStartTime, _workEndTime;   // DB 저장용

  // 시간 계산
  int startTimeSec;
  Timer timer;
  bool isWorking;

  Staff_info(name, roll) {
    this.name = name;
    this.roll = roll;
    this.isWorking = false;   // DB 연결하면 퇴근시간이 NULL일 때 TRUE로 설정
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
