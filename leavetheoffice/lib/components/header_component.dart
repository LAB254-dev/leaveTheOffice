import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 15),
                child: SizedBox(
                  height: 75,
                  width: 60,
                  child: Image.asset('assets/Logo.png'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  children: [
                    Text("(주) 랩이오사의 근태관리"),
                    Text("앱 서비스 입니다"),
                  ],
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
