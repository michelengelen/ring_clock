// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:analog_clock/CirclePainter.dart';
import 'package:flutter/material.dart';

@immutable
class DrawnMinutesRing extends StatefulWidget {
  const DrawnMinutesRing({
    @required this.inset,
    @required this.angleRadians,
    @required this.backgroundColor,
  })  : assert(inset != null),
        assert(angleRadians != null),
        assert(backgroundColor != null);

  final double angleRadians;
  final double inset;

  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _DrawnMinutesRingState();
}

class _DrawnMinutesRingState extends State<DrawnMinutesRing> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(DrawnMinutesRing oldWidget) {
    _controller.reset();
    _tween.begin = oldWidget.angleRadians;

    if (widget.angleRadians == 0.0 && oldWidget.angleRadians != 0.0) {
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
          painter: CirclePainter(
            inset: widget.inset,
            angleRadians: _animation.value,
            bgColor: widget.backgroundColor,
          ),
        ),
      ),
    );
  }
}
