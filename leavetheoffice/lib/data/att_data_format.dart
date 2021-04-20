class Date{
  int year;
  int month;
  int day;

  Date(this.year, this.month, this.day);

  String toString(){
    super.toString();
    return year.toString() + "-" + month.toString() + "-" + day.toString();
  }
}

class Time{
  int hour;
  int min;
  int sec;

  Time(this.hour, this.min, this.sec);

  String toString(){
    super.toString();
    return hour.toString() + ":" + min.toString() + ":" + sec.toString();
  }
}