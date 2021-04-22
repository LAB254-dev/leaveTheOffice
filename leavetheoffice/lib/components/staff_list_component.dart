import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/staff_component.dart';
import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/provider.dart';

import '../data/staff_info_data.dart';

class StaffList extends StatefulWidget {
  @override
  State createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Expanded(
      child: FutureBuilder(
          future: Future.wait([
            getDataManager().staffList(),
            getDataManager().getTodayAtts(Date(now.year, now.month, now.day))
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            // 데이터를 불러오는 중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // 데이터를 불러오는 데 성공
            if (snapshot.hasData) {
              List<Staff_info> staffList = snapshot.data[0];    // 데이터베이스에 저장된 모든 직원 정보
              List<Attendance> todayAtt = snapshot.data[1];     // 당일의 모든 근태 기록 (앱이 재시작 되거나 새로고침 된 경우 기존 기록을 불러오기 위함)

              // 근태 기록을 해당하는 직원에게 할당하기 위하여 기록 정렬 (
              List<Attendance> alignedAtt = new List(staffList.length);
              for (int i = 0; i < todayAtt.length; i++) {
                alignedAtt[todayAtt[i].id - 1] = todayAtt[i];     // autoincrement 세팅으로 생성된 직원 id가 1부터 시작하므로 -1
              }

              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                itemCount: staffList.length,
                itemBuilder: (context, index) {
                  return Staff(staffList[index], alignedAtt[index]);
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.45,
                ),
              );
            }
            return Center(child: Text("데이터 불러오기 실패"));
          }),
    );
  }
}
