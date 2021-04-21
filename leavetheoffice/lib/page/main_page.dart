import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leavetheoffice/components/header_component.dart';
import 'package:leavetheoffice/components/staff_list_component.dart';
import 'package:leavetheoffice/page/alert_page.dart';

import '../components/header_component.dart';
import '../components/staff_list_component.dart';

class MainPage extends StatefulWidget {
  // Future builder component를 사용하려면 StatefulWidget이어야 함
  static const routeName = '/';

  @override
  State createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // 어플리케이션 전체화면 설정
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("앵무시계"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      body: Center(
        child: Column(children: [
          Header(),
          StaffList(),
        ]),
      ),
    );
  }
}
