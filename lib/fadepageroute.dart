import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Widget child;
  FadePageRoute({@required this.child})
      : super(
            pageBuilder: (context, ani, ani2) {
              return child;
            },
            transitionDuration: Duration(milliseconds: 250),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation,child:child);
              // return ScaleTransition(scale: animation, child: child);
            });
}
