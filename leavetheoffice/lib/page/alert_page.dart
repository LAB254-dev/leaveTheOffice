import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/custom_button.dart';
import 'package:leavetheoffice/components/staff_component.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/page/main_page.dart';

class AlertPage extends StatefulWidget {
  static const routeName = '/alert';

  @override
  State<StatefulWidget> createState() {
    return _AlertPageState();
  }
}

class _AlertPageState extends State<AlertPage> {
  String name = "OOO";
  Staff_info args;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("앵무시계")),
      body: Container(
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                ),
                Image.asset(
                  "assets/Logo.png",
                  scale: 0.75,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      args.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "님",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Text(
                  "퇴근해주세요!",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                CustomButton("퇴근하기", _acceptClicked),
                CustomButton("취소", _cancelClicked, color: Color(0xFFE0E0E0), textColor: Color(0xFF616161),),
              ],
            )),
      ),
    );
  }

  void _acceptClicked() {
    args.switchIsWorking();
    args.setEndTime(DateTime.now());
    // update text components

    args.endTimer();

    Navigator.pop(context);
  }

  void _cancelClicked() {
    Navigator.pop(context);
  }
}
