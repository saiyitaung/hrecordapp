import 'package:flutter/material.dart';

class TotalHelpShow extends StatelessWidget {
  final Color color;
  final String title;
  final int totalCount;
  TotalHelpShow({this.color, this.title, this.totalCount});
  Widget build(BuildContext context) {
    double halfwith = MediaQuery.of(context).size.width / 2;
    return Container(
      width: halfwith,
      // color: color,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: color,fontFamily:"Padauk",),
        ),
        Text(
          "$totalCount",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ]),
    );
  }
}
