import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws the outer ring with hour-indicator arrow.
/// This is different from the [InnerCirclePainter] because
/// it clips the canvas instead of drawing a new circle on it.
/// Otherwise this could have been made a single class
class OuterCirclePainter extends CustomPainter {
  OuterCirclePainter({
    @required this.angleRadians,
    @required this.arrowSize,
    @required this.backgroundColor,
  })  : assert(angleRadians != null),
        assert(arrowSize != null),
        assert(backgroundColor != null);

  /// the current tick the arrow points to
  final double angleRadians;

  /// the size of the arrow
  /// will be painted as a half-square on the rings edge
  final double arrowSize;

  /// backgroundColor set from the customTheme
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    /// since this is used widely in the method we store it here
    final double startRadians = -math.pi / 2.0;
    final double sweepRadians = math.pi * 2.0;

    /// center-Offset for later use
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);

    /// leave 10% padding on the shortest side
    final double radius = math.min(size.width * 0.4, size.height * 0.4);

    /// the exact spot the arrow is pointing to on the clock-base
    final Offset arrowPointOffset = center +
        Offset(math.cos(startRadians + angleRadians), math.sin(startRadians + angleRadians)) * (radius - arrowSize);

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

    /// draw the complete clipping-path (incl. the inner ring-path)
    final Path _clipPath = Path()
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..addPath(_innerPath, Offset.zero)
      ..fillType = PathFillType.evenOdd;

    /// [Paint] for the area around the clock
    final Paint fillPaint = Paint()..color = backgroundColor;

    /// [Paint] for the shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

    /// Steps in this paint are as follows:
    ///   1. draw the shadow
    ///   2. inverse clip the inner area from the canvas
    ///   3. fill the clipped area with the given backgroundColor
    canvas
      ..drawPath(_innerPath, shadowPaint)
      ..clipPath(_clipPath)
      ..drawPaint(fillPaint);
  }

  @override
  bool shouldRepaint(OuterCirclePainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians ||
        oldDelegate.arrowSize != arrowSize ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
