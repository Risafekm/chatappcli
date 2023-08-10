// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';

class ScaleAnimation extends StatefulWidget {
  final Widget child;
  final int delayTime;

  const ScaleAnimation({
    Key? key,
    required this.child,
    required this.delayTime,
  }) : super(key: key);

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _sizeAnimation;
  bool isSize = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    final _curve = CurvedAnimation(parent: _controller, curve: Curves.bounceIn);

    _scaleAnimation = Tween<double>(begin: 0.60, end: 1.1).animate(_curve);

    if (widget.delayTime == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.delayTime), () {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (
        BuildContext context,
        Widget? _,
      ) {
        return ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        );
      },
    );
  }
}
