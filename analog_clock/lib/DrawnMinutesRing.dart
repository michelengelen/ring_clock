// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:analog_clock/InnerCirclePainter.dart';
import 'package:flutter/material.dart';

@immutable
class DrawnMinutesRing extends StatefulWidget {
  const DrawnMinutesRing({
    @required this.inset,
    @required this.angleRadians,
    @required this.arrowSize,
  })  : assert(inset != null),
        assert(angleRadians != null),
        assert(arrowSize != null);

  /// the current angle
  final double angleRadians;

  /// arrow-size
  final double arrowSize;

  /// the amount of space between the rings
  /// (should be equal to the baseWidth of the [DrawnClockBase])
  final double inset;

  @override
  State<StatefulWidget> createState() => _DrawnMinutesRingState();
}

/// [State] to make animation of clock-rings possible
class _DrawnMinutesRingState extends State<DrawnMinutesRing> with SingleTickerProviderStateMixin {
  /// the [AnimationController] responsible for the animation
  AnimationController _controller;

  /// [Tween] for calculating the correct values
  Tween<double> _tween;

  /// [Animation] which holds the values
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..addListener(() {
        setState(() {});
      });

    /// when initiating the [State] set both [_tween] values to the initial value
    _tween = Tween<double>(
      begin: widget.angleRadians,
      end: widget.angleRadians,
    );

    _animation = _tween.animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
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

    /// just letting it to the values would result in strange
    /// animations once the full second/minute/hour was reached
    if (widget.angleRadians == 0.0 && oldWidget.angleRadians != 0.0) {
      /// if the new angleRadians is 0.0 (meaning it is a full minute/hour)
      /// just set it to `math.pi * 2` (which is basically the same as `0.0`)
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
            arrowSize: widget.arrowSize,
            backgroundColor: Theme.of(context).backgroundColor,
          ),
        ),
      ),
    );
  }
}
