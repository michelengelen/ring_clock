import 'dart:math' as math;

import 'package:analog_clock/OuterCirclePainter.dart';
import 'package:flutter/material.dart';

/// [CustomPainter] that draws the inner ring with minute-indicator arrow.
/// This is different from the [OuterCirclePainter] because
/// it simply draws a new circle on it instead of clipping.
class CirclePainter extends CustomPainter {
  CirclePainter({
    @required this.inset,
    @required this.angleRadians,
    @required this.arrowSize,
    @required this.backgroundColor,
  })  : assert(inset != null),
        assert(angleRadians != null),
        assert(arrowSize != null),
        assert(backgroundColor != null);

  /// the amount the inner Ring is set inwards
  double inset;

  /// the current tick the arrow points to
  double angleRadians;

  /// the size of the arrow
  /// will be painted as a half-square on the rings edge
  double arrowSize;

  /// backgroundColor set from the customTheme
  Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    /// since this is used widely in the method we store it here
    final double startRadians = -math.pi / 2.0;
    final double sweepRadians = math.pi * 2.0;

    /// center-Offset for later use
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);

    /// leave 10% padding on the shortest side
    final double radius = math.min(size.width * 0.4 - inset, size.height * 0.4 - inset);

    /// the exact spot the arrow is pointing to on the clock-base
    final Offset arrowPointOffset = center +
      Offset(math.cos(startRadians + angleRadians), math.sin(startRadians + angleRadians)) * (radius + arrowSize);

    /// calculate the radians of the arrow, since the radius of the
    /// inner circle is not equal to the outer circle.
    /// This results in different radians the arrow needs to occupy
    final double u = math.pi * 2 * radius;
    final double arrowDelta = arrowSize / u;
    final double arrowRadians = math.pi * 2 * arrowDelta;

    /// the rect is needed for the arc
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    /// measured angles (start and sweep) for the Outer Circle
    final double innerStartAngle = startRadians + angleRadians + arrowRadians;
    final double innerSweepAngle = sweepRadians - (2 * arrowRadians);

    /// create the path for the ring with indicator first, because
    /// we need it as standalone afterwards for drawing the shadow
    final Path _innerPath = Path()
      ..addArc(rect, innerStartAngle, innerSweepAngle)
      ..lineTo(arrowPointOffset.dx, arrowPointOffset.dy)
      ..close();

    /// [Paint] for filling the inner circle with the themes backgroundColor
    final Paint _fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    /// Steps in drawing the inner circle:
    ///   1. draw the shadow first
    ///   2. draw the inner circle
    canvas
    ..drawShadow(_innerPath, Colors.black, 5.0, true)
      ..drawPath(_innerPath, _fillPaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.inset != inset ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.arrowSize != arrowSize ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
