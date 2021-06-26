import 'package:flutter/material.dart';

class ScalePageRoute extends PageRouteBuilder {
  final Widget child;
  ScalePageRoute({@required this.child})
      : super(
            pageBuilder: (context, ani, ani2) {
              return child;
            },
            transitionDuration: Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return ScaleTransition(scale: animation, child: child);
            });
}
