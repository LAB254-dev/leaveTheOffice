import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/staff_component.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';

class StaffList extends StatefulWidget {
  @override
  State createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    List<Staff_info> staffList = [
      Staff_info("이아영", "DESIGNER"),
      Staff_info("김도연", "DEVELOPER"),
      Staff_info("박지윤", "DEVELOPER"),
      Staff_info("박정아", "PM"),
      Staff_info("상한규", "INTERN")
    ];

    GridView memberGrid = GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        return Staff(staffList[index].name, staffList[index].roll);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.45,
      ),
    );

    return Container(
      child: memberGrid,
    );
  }
}
