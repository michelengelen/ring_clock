import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws the outer ring with indicator.
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

  final double angleRadians;
  final double arrowSize;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    /// center-Offset for later use
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);

    /// leave 10% padding on the shortest side
    final double radius = math.min(size.width * 0.4, size.height * 0.4);

    /// the exact spot the arrow is pointing to on the clock-base
    final Offset arrowPointOffset = center +
        Offset(math.cos(-math.pi / 2.0 + angleRadians), math.sin(-math.pi / 2.0 + angleRadians)) * (radius - 25);

    final double u = math.pi * 2 * radius;
    final double arrowDelta = 25 / u;
    final double arrowWidth = math.pi * 2 * arrowDelta;

    /// the rect is needed for the arc
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    /// measured angles (start and sweep) for the Outer Circle
    final double startAngle = (-math.pi / 2.0) + angleRadians + arrowWidth;
    final double sweepAngle = (math.pi * 2.0) - (2 * arrowWidth);

    /// create the path for the ring with indicator first, because
    /// we need it as standalone afterwards for drawing the shadow
    final Path _innerPath = Path()
      ..addArc(rect, startAngle, sweepAngle)
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
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    /// Steps in this paint are as follows:
    ///   1. draw the shadow
    ///   2. inverse clip the inner area from the canvas
    ///   3. fill the clipped area with the given backgroundColor
    ///   4. save canvas
    ///   5. restore canvas
    canvas
      ..drawPath(_innerPath, shadowPaint)
      ..clipPath(_clipPath)
      ..drawPaint(fillPaint);
  }

  @override
  bool shouldRepaint(OuterCirclePainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians;
  }
}
