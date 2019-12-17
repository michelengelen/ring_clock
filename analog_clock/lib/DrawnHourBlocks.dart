import 'package:analog_clock/BlockPainter.dart';
import 'package:flutter/material.dart';

class DrawnHourBlocks extends StatelessWidget {
  const DrawnHourBlocks({
    @required this.thickness,
    @required this.inset,
    @required this.hour,
  })  : assert(thickness != null);

  final double thickness;
  final double inset;
  final int hour;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: CustomPaint(
          painter: BlockPainter(
            color: Colors.grey,
            thickness: thickness,
            inset: inset,
            tick: hour,
            blocks: 12,
          ),
      ),
    );
  }
}
