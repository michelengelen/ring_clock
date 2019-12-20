import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws a clock hand.
class OuterCirclePainter extends CustomPainter {
  OuterCirclePainter({
    @required this.angleRadians,
    @required this.backgroundColor,
  })  : assert(angleRadians != null),
        assert(backgroundColor != null);

  double angleRadians;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    /// center-Offset for later use
    final Offset center = Offset(size.width / 2, size.height / 2);
    /// leave 10% padding on the shortest side
    final double radius = math.min(size.width * 0.4, size.height * 0.4);

    /// the exact spot the arrow is pointing to on the clock-base
    final Offset arrowPointOffset = center +
        Offset(math.cos(-math.pi / 2.0 + angleRadians), math.sin(-math.pi / 2.0 + angleRadians)) * (radius - 15);

    final double arrowWidth = math.pi * 2 / 120;

    /// the rect is needed for the arc
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    /// measured angles (start and sweep) for the Outer Circle
    final double startAngle = (-math.pi / 2.0) + angleRadians + arrowWidth;
    final double sweepAngle = (math.pi * 2.0) - (2 * arrowWidth);
    final Path _innerPath = Path()
      ..addArc(rect, startAngle, sweepAngle)
      ..lineTo(arrowPointOffset.dx, arrowPointOffset.dy)
      ..close();

    final Path _clipPath = Path()
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..addPath(_innerPath, Offset.zero)
      ..fillType = PathFillType.evenOdd;

    final Paint fillPaint = Paint()..color = backgroundColor;

    final Paint shadowPaint = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

    canvas
      ..drawPath(_innerPath, shadowPaint)
      ..clipPath(_clipPath)
      ..drawPaint(fillPaint)
      ..save()
      ..restore();
  }

  @override
  bool shouldRepaint(OuterCirclePainter oldDelegate) {
    return oldDelegate.angleRadians != angleRadians;
  }
}
