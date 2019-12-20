import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws a clock hand.
class CirclePainter extends CustomPainter {
  CirclePainter({
    @required this.inset,
    @required this.angleRadians,
    @required this.arrowSize,
    @required this.bgColor,
  })  : assert(inset != null),
        assert(angleRadians != null),
        assert(arrowSize != null),
        assert(bgColor != null);

  double inset;
  double angleRadians;
  double arrowSize;
  Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width * 0.4 - inset, size.height * 0.4 - inset);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Offset arrowPointOffset = center +
        Offset(math.cos(-math.pi / 2.0 + angleRadians), math.sin(-math.pi / 2.0 + angleRadians)) * (radius + 25);

    final double u = math.pi * 2 * radius;
    final double arrowDelta = 25 / u;
    final double arrowWidth = math.pi * 2 * arrowDelta;

    final double startAngle = (-math.pi / 2.0) + angleRadians + arrowWidth;
    final double sweepAngle = (math.pi * 2.0) - (2 * arrowWidth);

    final Path _path = Path()
      ..addArc(rect, startAngle, sweepAngle)
      ..lineTo(arrowPointOffset.dx, arrowPointOffset.dy)
      ..close();

    final Paint fillPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final Paint shadowPaint = Paint()
      ..color = Colors.black38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);

    canvas.drawPath(_path, shadowPaint);
    canvas.drawPath(_path, fillPaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.inset != inset || oldDelegate.angleRadians != angleRadians || oldDelegate.bgColor != bgColor;
  }
}
