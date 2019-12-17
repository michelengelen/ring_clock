import 'dart:math' as math;

import 'package:analog_clock/TimeClipper.dart';
import 'package:flutter/material.dart';

@immutable
class InnerClock extends StatelessWidget {
  const InnerClock({
    @required this.size,
    @required this.hour,
    @required this.minute,
  });

  final double size;
  final int hour;
  final int minute;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      color: Colors.grey[200],
      fontSize: size * 0.9,
      fontWeight: FontWeight.bold,
    );

    final double gap = size / 10;

    final String _hour = hour > 9 ? '$hour' : '0$hour';
    final String _minute = minute > 9 ? '$minute' : '0$minute';

    return Center(
      child: Container(
        width: size * 2,
        height: size,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: size - gap,
              child: ClipPath(
                clipper: TimeClipper(edge: clippingEdges.BOTTOM_RIGHT),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(_hour, style: style),
                ),
              ),
            ),
            SizedBox.expand(
              child: CustomPaint(
                painter: _DrawnSeparator(
                  length: size,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: size - gap,
              child: ClipPath(
                clipper: TimeClipper(edge: clippingEdges.TOP_LEFT),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(_minute, style: style),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawnSeparator extends CustomPainter {
  _DrawnSeparator({
    @required this.length,
  });

  final double length;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = (Offset.zero & size).center;
    final double angle = -2 * (math.pi / 5);
    final Offset position = Offset(math.cos(angle), math.sin(angle));
    final Offset start = center - position * length / 2.0;
    final Offset end = center + position * length / 2.0;
    final Paint _paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    // drawing
    canvas.drawLine(start, end, _paint);
  }

  @override
  bool shouldRepaint(_DrawnSeparator oldDelegate) {
    return false;
  }
}
