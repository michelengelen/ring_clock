import 'dart:math' as math;

import 'package:flutter/material.dart';

/// [CustomPainter] that draws the base of the clock below the rings.
class _ClockBasePainter extends CustomPainter {
  _ClockBasePainter({
    @required this.primaryColor,
    @required this.accentColor,
    @required this.tickColor,
    @required this.baseWidth,
  })  : assert(primaryColor != null),
        assert(accentColor != null),
        assert(tickColor != null),
        assert(baseWidth != null);

  /// [Color] used as the base inner color-stop
  final Color primaryColor;

  /// [Color] used as the base outer color-stops
  final Color accentColor;

  /// [Color] used for the ticks
  final Color tickColor;

  /// the width the base will have
  final double baseWidth;

  @override
  void paint(Canvas canvas, Size size) {
    /// to be consistent store it first
    final double sweepRadians = math.pi * 2.0;

    /// center-Offset for later use
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);

    /// leave 10% padding on the shortest side
    final double radius = math.min(size.width * 0.4, size.height * 0.4);

    /// [Rect] to draw the gradient
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    /// Color list to be used in the clock-base gradient
    final List<Color> _gradientColors = <Color>[
      accentColor,
      primaryColor,
      accentColor,
    ];

    /// corresponding color-stops
    /// calculation is for only filling the clock-base
    final List<double> _gradientStops = <double>[
      (radius - baseWidth) / radius,
      (radius - baseWidth / 2.0) / radius,
      1.0,
    ];

    /// the complete [Gradient] to fill the clock-base
    final Gradient _fillGradient = RadialGradient(
      colors: _gradientColors,
      stops: _gradientStops,
    );

    /// clock-base Paint
    final Paint _fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = _fillGradient.createShader(rect);

    /// draw the rect
    /// it fills the entire canvas - I could have used drawPaint() here,
    /// but that is strangely not bound to the canvas-size and fills the entire screen
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _fillPaint);

    /// prepare rendering of the tick-marks
    final double _tickLength = baseWidth * 0.5;
    final double _tickPadding = baseWidth * 0.25;
    final double _tickAngle = sweepRadians / 60;

    /// save the canvas
    canvas.save();

    /// the [Paint] used to draw the ticks
    final Paint tickPaint = Paint()
      ..color = tickColor
      ..style = PaintingStyle.stroke;

    /// center the canvas for easier calculations
    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < 60; i++) {
      /// increase the strokeWidth of the hour tick marker
      tickPaint.strokeWidth = i % 5 == 0 ? 8.0 : 2.0;

      /// draw the tick to the canvas
      /// ticks will be drawn centered to the baseWidth
      canvas.drawLine(
        Offset(0.0, radius - baseWidth + _tickPadding),
        Offset(0.0, radius - baseWidth + _tickPadding + _tickLength),
        tickPaint,
      );

      /// rotate the canvas for the next tick to be painted
      canvas.rotate(_tickAngle);
    }

    /// restore the canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ClockBasePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.baseWidth != baseWidth;
  }
}

/// Implementation class for the [_ClockBasePainter]
class DrawnClockBase extends StatelessWidget {
  const DrawnClockBase({
    @required this.primaryColor,
    @required this.accentColor,
    @required this.tickColor,
    @required this.baseWidth,
  })  : assert(primaryColor != null),
        assert(accentColor != null),
        assert(tickColor != null),
        assert(baseWidth != null);

  final Color primaryColor;
  final Color accentColor;
  final Color tickColor;
  final double baseWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _ClockBasePainter(
            primaryColor: primaryColor,
            accentColor: accentColor,
            tickColor: tickColor,
            baseWidth: baseWidth,
          ),
        ),
      ),
    );
  }
}
