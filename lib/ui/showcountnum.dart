import 'package:flutter/material.dart';

class ShowCount extends StatelessWidget {
  final int count;
  final Color color;
  final bool isfinished;
  ShowCount({this.count, this.color, this.isfinished});
  Widget build(BuildContext context) {
    return Text(
      "$count",
      style: TextStyle(
          color: isfinished ? color.withOpacity(.5) : color,
          fontSize: 18,
          decoration: isfinished ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.bold),
    );
  }
}
