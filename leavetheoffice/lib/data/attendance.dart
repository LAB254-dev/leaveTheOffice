import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/provider.dart';

class Attendance{
  //DB
  static const String attTableName = "attendance";
  static const String columnId = "id";
  static const String columnDate = "date";
  static const String columnStart = "start";
  static const String columnEnd = "end";

  //variable
  int id;
  Date date;
  Time start, end;

  Attendance(this.id, this.date, this.start, {this.end});
}