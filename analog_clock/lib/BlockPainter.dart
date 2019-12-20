import 'dart:math' as math;
import 'package:flutter/material.dart';

/// [CustomPainter] that draws the hour indicators
class BlockPainter extends CustomPainter {
  BlockPainter({
    @required this.thickness,
    @required this.inset,
    @required this.tick,
    @required this.blocks,
    @required this.color,
  });

  double thickness;
  double inset;
  int tick;
  int blocks;
  MaterialColor color;

  @override
  void paint(Canvas canvas, Size size) {
    const double gap = math.pi / 1200;

    final double angle = (2 * math.pi / blocks) - (2 * gap);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width / 2 - inset, size.height / 2 - inset);

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final List<double> stops = <double>[
      (radius - (thickness / 2)) / radius,
      1.0,
      (radius + (thickness / 2)) / radius,
    ];

    // drawing
    for (int i = 0; i < blocks; i++) {
      const double start = -math.pi / 2.0;
      final double hourStart = start + gap + (i * (angle + 2 * gap));

      final List<Color> colors = <Color>[
        i < tick ? color.shade200 : color.shade700,
        i < tick ? color.shade400 : color.shade800,
        i < tick ? color.shade300 : color.shade700,
      ];

      final Gradient gradient = RadialGradient(
        colors: colors,
        stops: stops,
      );

      final Paint complete = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..shader = gradient.createShader(rect);

      canvas.drawArc(rect, hourStart, angle, false, complete);
    }
  }

  @override
  bool shouldRepaint(BlockPainter oldDelegate) {
    return oldDelegate.thickness != thickness ||
      oldDelegate.tick != tick;
  }
}