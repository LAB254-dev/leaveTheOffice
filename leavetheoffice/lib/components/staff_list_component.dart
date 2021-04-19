import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/staff_component.dart';
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
    return Expanded(
      child: FutureBuilder(
          future: getDataManager().staffList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              List<Staff_info> staffList = snapshot.data;
              debugPrint(staffList.isNotEmpty ? staffList[0].name : "List Empty");
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                itemCount: staffList.length,
                itemBuilder: (context, index) {
                  return Staff(
                      staffList[index]);
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
