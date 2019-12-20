import 'dart:math' as math;

import 'package:flutter/material.dart';

class ClockBasePainter extends CustomPainter {
  ClockBasePainter({@required this.primaryColor, @required this.accentColor, @required this.baseWidth})
      : assert(primaryColor != null),
        assert(accentColor != null),
        assert(baseWidth != null);

  final Color primaryColor;
  final Color accentColor;
  final double baseWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width * 0.4, size.height * 0.4);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final List<Color> primaryColors = <Color>[
      accentColor,
      accentColor,
      primaryColor,
      accentColor,
    ];

    final List<double> fillStops = <double>[
      0.0,
      (radius - baseWidth) / radius,
      (radius - baseWidth / 2.0) / radius,
      1.0,
    ];

    final Gradient fillGradient = RadialGradient(
      colors: primaryColors,
      stops: fillStops,
    );

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = fillGradient.createShader(rect);

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), fillPaint);

    final double tickMarkLength = baseWidth * 0.6;
    final double basePadding = baseWidth * 0.2;
    final double angle = 2 * math.pi / 60;

    canvas.save();

    final Paint tickPaint = Paint()
      ..color = Colors.white38
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    // drawing of the ticks
    canvas.translate(center.dx, center.dy);
    for (int i = 0; i < 60; i++) {

      // make the stroke of the tick marker thicker
      tickPaint.strokeWidth= i % 5 == 0 ? 12.0 : 2.0;

      canvas.drawLine(
        Offset(0.0, radius - baseWidth + basePadding),
        Offset(0.0, radius - baseWidth + basePadding + tickMarkLength),
        tickPaint,
      );

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(ClockBasePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor || oldDelegate.accentColor != accentColor;
  }
}

class DrawnClockBase extends StatelessWidget {
  const DrawnClockBase({
    @required this.primaryColor,
    @required this.accentColor,
    @required this.baseWidth,
  });

  final Color primaryColor;
  final Color accentColor;
  final double baseWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: ClockBasePainter(
            primaryColor: primaryColor,
            accentColor: accentColor,
            baseWidth: baseWidth,
          ),
        ),
      ),
    );
  }
}
