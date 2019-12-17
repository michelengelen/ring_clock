import 'dart:math';

import 'package:flutter/material.dart';

class ClockBasePainter extends CustomPainter {
  ClockBasePainter({@required this.bgColor, @required this.width});

  final Color bgColor;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2 + (width / 2.0), size.height / 2 + (width / 2.0));

    final Paint _paint = Paint()
      ..color = bgColor
      ..strokeWidth = width
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DrawnClockBase extends StatelessWidget {
  const DrawnClockBase({@required this.bgColor, @required this.width});

  final Color bgColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: ClockBasePainter(bgColor: bgColor, width: width),
        ),
      ),
    );
  }
}
