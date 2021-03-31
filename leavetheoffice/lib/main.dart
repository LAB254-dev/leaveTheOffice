import 'package:flutter/material.dart';
import 'package:leavetheoffice/page/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '퇴근 준비',
      theme: ThemeData(
        primaryColor: Colors.lightBlue.shade600,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => MainPage(),
      },
    );
  }
}

