import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String title;
  VoidCallback callback;
  Color color = Colors.lightBlue.shade600;
  Color textColor = Colors.white;

  CustomButton(this.title, this.callback, {this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(300, 15),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          primary: color,
          onPrimary: textColor,
          padding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 15,
          ),
        ),
        child: Text(title),
        onPressed: callback,
      ),
    );
  }
}
