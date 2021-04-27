import 'package:leavetheoffice/data/att_data_format.dart';

class Attendance{
  // 근태 관리에 필요한 변수들을 이 클래스로 관리

  //DB table / column 이름 정의
  static const String attTableName = "attendance";
  static const String columnId = "attId";
  static const String columnDate = "date";
  static const String columnStart = "start";
  static const String columnEnd = "end";

  //variable
  int id;
  Date date;
  Time start, end;    // 근무 시작시간, 끝 시간

  Attendance(this.id, this.date, this.start, {this.end});
}