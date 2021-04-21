import 'package:flutter/cupertino.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/page/alert_page.dart';
import 'package:path/path.dart';

class PageManager {
  List<Staff_info> _infoQueue = [];
  List<BuildContext> _contextQueue = [];
  int current = -1;

  void pushPageArgs(BuildContext context, Staff_info argument) {
    _infoQueue.add(argument);
    _contextQueue.add(context);
    if (_infoQueue.length == 1) {
      _pushPage(context, argument);
    }
  }

  void broadcastPop(int current) {
    if (this.current == current) {
      Navigator.pop(_contextQueue[0]);
      _infoQueue.removeAt(0);
      _contextQueue.removeAt(0);
      if (_infoQueue.isNotEmpty) {
        _pushPage(_contextQueue[0], _infoQueue[0]);
      }
      else{
        this.current = -1;
      }
    }
  }

  void _pushPage(BuildContext context, Staff_info argument) {
    current = argument.id;
    Navigator.pushNamed(context, AlertPage.routeName, arguments: argument);
  }
}
