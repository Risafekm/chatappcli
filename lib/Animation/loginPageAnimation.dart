// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';

class DelayedAnimation extends StatefulWidget {
  final Widget child;
  final int delayedAnimation;
  final double aniOffsetX;
  final double aniOffsetY;
  final int aniDuration;

  const DelayedAnimation({
    Key? key,
    required this.child,
    required this.delayedAnimation,
    required this.aniOffsetX,
    required this.aniOffsetY,
    required this.aniDuration,
  }) : super(key: key);

  @override
  State<DelayedAnimation> createState() => _DelayedAnimationState();
}

class _DelayedAnimationState extends State<DelayedAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.aniDuration),
    );

    final curve = CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.75, curve: Curves.easeIn));

    _animationOffset = Tween<Offset>(
            begin: Offset(widget.aniOffsetX, widget.aniOffsetY),
            end: Offset.zero)
        .animate(curve);

    if (widget.delayedAnimation == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.delayedAnimation), () {
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
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animationOffset,
        child: widget.child,
      ),
    );
  }
}
