// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:analog_clock/CirclePainter.dart';
import 'package:flutter/material.dart';

@immutable
class DrawnSecondRing extends StatefulWidget {
  const DrawnSecondRing({
    @required this.color,
    @required this.fillColor,
    @required this.thickness,
    @required this.inset,
    @required this.angleRadians,
  })  : assert(color != null),
        assert(angleRadians != null);

  /// Hand color.
  final Color color;
  final Color fillColor;

  /// The angle, in radians, at which the hand is drawn.
  /// This angle is measured from the 12 o'clock position.
  final double angleRadians;

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;
  final double inset;

  @override
  State<StatefulWidget> createState() => _DrawnSecondRingState();
}

class _DrawnSecondRingState extends State<DrawnSecondRing> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<double> _tween;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {});
      });

    _tween = Tween<double>(
      begin: widget.angleRadians,
      end: widget.angleRadians,
    );

    _animation = _tween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
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
  void didUpdateWidget(DrawnSecondRing oldWidget) {
    _controller.reset();
    _tween.begin = oldWidget.angleRadians;

    if (widget.angleRadians == 0.0) {
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
//    print('#### angleRadians value: ${_animation.value}');
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: CirclePainter(
            lineWidth: widget.thickness,
            angleRadians: _animation.value,
            color: widget.color,
            inset: widget.inset,
            fillColor: widget.fillColor,
          ),
        ),
      ),
    );
  }
}
