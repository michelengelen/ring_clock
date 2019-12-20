// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:analog_clock/OuterCirclePainter.dart';
import 'package:flutter/material.dart';

@immutable
class DrawnHoursRing extends StatefulWidget {
  const DrawnHoursRing({
    @required this.angleRadians,
    @required this.arrowSize,
    @required this.backgroundColor,
  })  : assert(angleRadians != null),
        assert(arrowSize != null),
        assert(backgroundColor != null);

  final double angleRadians;
  final double arrowSize;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _DrawnHoursRingState();
}

class _DrawnHoursRingState extends State<DrawnHoursRing> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<double> _tween;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        setState(() {});
      });

    _tween = Tween<double>(
      begin: widget.angleRadians,
      end: widget.angleRadians,
    );

    _animation = _tween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad, reverseCurve: Curves.easeInOut),
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DrawnHoursRing oldWidget) {
    _controller.reset();
    _tween.begin = oldWidget.angleRadians;

    if (widget.angleRadians == 0.0 && oldWidget.angleRadians != widget.angleRadians) {
      _tween.end = math.pi * 2;
      _controller.forward();
    } else {
      _tween.end = widget.angleRadians;
      _controller.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: OuterCirclePainter(
            angleRadians: _animation.value,
            arrowSize: widget.arrowSize,
            backgroundColor: widget.backgroundColor,
          ),
        ),
      ),
    );
  }
}
