import 'dart:async';

import 'staff_info_data.dart';
import 'staff_info_data.dart';

class DataManager{
  List<Staff_info> _staffs= [
    Staff_info("이아영", "DESIGNER"),
    Staff_info("김도연", "DEVELOPER"),
    Staff_info("박지윤", "DEVELOPER"),
    Staff_info("박정아", "PM"),
    Staff_info("상한규", "INTERN"),
    Staff_info("당병진", "DEVELOPER"),
    Staff_info("Test", "test"),
    Staff_info("Test", "teeest"),
    Staff_info("Test2", "teeeeest"),
    Staff_info("name", "roll")
  ];

  List<Staff_info> getStaffs(){
    return _staffs;
  }

  Staff_info getStaffInfo(int index){
    return _staffs[index];
  }

  void startTimer(int index, Timer timer){
    _staffs[index].timer = timer;
  }

  void endTimer(int index){
    _staffs[index].timer?.cancel();
  }

  bool isWorking(int index){
    return _staffs[index].isWorking;
  }

  void switchIsWorking(int index){
    _staffs[index].isWorking = !_staffs[index].isWorking;
  }
}