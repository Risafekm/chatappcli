import 'package:flutter/material.dart';

class FadePageRouteAnimation extends PageRouteBuilder {
  final Widget widget;
  final Curve curves;
  final Duration animationTime;

  FadePageRouteAnimation(
      {required this.widget, required this.curves, required this.animationTime})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: animationTime,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            animation = Tween(begin: 0.0, end: 1.0)
                .animate(CurvedAnimation(parent: animation, curve: curves));
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
