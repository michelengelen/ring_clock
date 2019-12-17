import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws a clock hand.
class CirclePainter extends CustomPainter {
  CirclePainter({
    @required this.lineWidth,
    @required this.inset,
    @required this.angleRadians,
    @required this.color,
    @required this.fillColor,
  })  : assert(lineWidth != null),
      assert(angleRadians != null),
      assert(color != null);

  double handSize;
  double lineWidth;
  double inset;
  double angleRadians;
  Color color;
  Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width / 2 - inset, size.height / 2 - inset);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final Rect dotRect = Rect.fromCircle(
      center: center + Offset(math.cos(-math.pi / 2.0 + angleRadians), math.sin(-math.pi / 2.0 + angleRadians)) * radius,
      radius: lineWidth * 1.15
    );
    final dotPath = Path()..addOval(dotRect);

    final Paint emptyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;
    final Paint dotPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, emptyPaint);
    canvas.drawArc(rect, -math.pi / 2.0, angleRadians, false, fillPaint);
    canvas.drawShadow(dotPath, Colors.black, 2.0, true);
    canvas.drawCircle(
      center + Offset(math.cos(-math.pi / 2.0 + angleRadians), math.sin(-math.pi / 2.0 + angleRadians)) * radius,
      lineWidth,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
      oldDelegate.lineWidth != lineWidth ||
      oldDelegate.angleRadians != angleRadians ||
      oldDelegate.color != color;
  }
}