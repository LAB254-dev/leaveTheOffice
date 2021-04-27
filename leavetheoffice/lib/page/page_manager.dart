import 'package:flutter/cupertino.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/page/alert_page.dart';

class PageManager {
  // FIFO queue
  List<Staff_info> _infoQueue = [];
  List<BuildContext> _contextQueue = [];
  
  // 현재 열려있는 페이지 id (직원 번호 사용)
  int current = -1;

  void pagePushRequest(BuildContext context, Staff_info argument) {
    // staff component가 페이지 푸쉬를 요청할 때 호출
    _infoQueue.add(argument);
    _contextQueue.add(context);

    // 대기하고 있는 페이지가 없으면 받은 페이지를 바로 푸쉬
    if (_infoQueue.length == 1) {
      _pushPage(context, argument);
    }
  }

  void broadcastPop(int current) {
    // alert 페이지가 닫힘을 알릴 때 호출

    // 여러 페이지 중 닫으려는 페이지를 식별하여 닫음
    if (this.current == current) {
      Navigator.pop(_contextQueue[0]);
      _infoQueue.removeAt(0);
      _contextQueue.removeAt(0);

      // 대기하고 있는 다음 페이지를 호출
      if (_infoQueue.isNotEmpty) {
        _pushPage(_contextQueue[0], _infoQueue[0]);
      }
      else{
        this.current = -1;
      }
    }
  }

  void _pushPage(BuildContext context, Staff_info argument) {
    // 페이지 푸쉬
    current = argument.id;
    Navigator.pushNamed(context, AlertPage.routeName, arguments: argument);
  }
}
