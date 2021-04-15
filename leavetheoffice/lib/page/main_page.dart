import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leavetheoffice/components/header_component.dart';
import 'package:leavetheoffice/components/staff_list_component.dart';

import '../components/header_component.dart';
import '../components/staff_list_component.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("앵무시계"),
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
