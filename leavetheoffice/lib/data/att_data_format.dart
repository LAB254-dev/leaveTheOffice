//데이터 관리에 용이하도록 Date class와 Time class 정의

class Date{
  // 날짜를 저장하기 위한 포맷
  int year;
  int month;
  int day;

  Date(this.year, this.month, this.day);

  String toString(){
    // SQLite는 DateTime 형식을 지원하지 않기 때문에 일정한 규칙에 따라 문자열로 변환
    super.toString();
    return year.toString() + "-" + month.toString() + "-" + day.toString();
  }
}

class Time{
  // 시간을 저장하기 위한 포맷
  int hour;
  int min;
  int sec;

  Time(this.hour, this.min, this.sec);

  String toString(){
    super.toString();
    return hour.toString() + ":" + min.toString() + ":" + sec.toString();
  }
}