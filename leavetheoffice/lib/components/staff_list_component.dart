import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/staff_component.dart';
import 'package:leavetheoffice/data/att_data_format.dart';
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
          future: getDataManager().getStaffInfoListWithAttendance(Date(now.year, now.month, now.day)),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            // 데이터를 불러오는 중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // 데이터를 불러오는 데 성공
            if (snapshot.hasData) {
              List<Staff_info> staffList = snapshot.data;

              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                itemCount: staffList.length,
                itemBuilder: (context, index) {
                  return Staff(staffList[index]);
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
