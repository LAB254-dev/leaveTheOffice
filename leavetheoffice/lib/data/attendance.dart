class Attendance{
  //DB
  static const String attTableName = "attendance";
  static const String columnId = "id";
  static const String columnDate = "date";
  static const String columnStart = "start";
  static const String columnEnd = "end";

  //variable
  int id;
  DateTime date, start, end;

  Attendance(this.id);
}