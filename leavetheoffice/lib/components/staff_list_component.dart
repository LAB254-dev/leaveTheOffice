import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/staff_component.dart';
import 'package:leavetheoffice/data/staff_info_data.dart';
import 'package:leavetheoffice/provider.dart';

import '../data/staff_info_data.dart';
import '../data/staff_info_data.dart';

class StaffList extends StatefulWidget {
  @override
  State createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  @override
  Widget build(BuildContext context) {
    List<Staff_info> staffList = getDataManager().getStaffs();

    GridView memberGrid = GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        return Staff(index, staffList[index].name, staffList[index].roll);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.45,
      ),
    );

    return Expanded(
      child: memberGrid,
    );
  }
}
