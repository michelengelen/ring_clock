import 'package:analog_clock/BlockPainter.dart';
import 'package:flutter/material.dart';

class DrawnMinutesBlocks extends StatelessWidget {
  const DrawnMinutesBlocks({
    @required this.thickness,
    @required this.inset,
    @required this.minute,
  })  : assert(thickness != null);

  final double thickness;
  final double inset;
  final int minute;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: CustomPaint(
          painter: BlockPainter(
            color: Colors.grey,
            thickness: thickness,
            inset: inset,
            tick: minute,
            blocks: 60,
          ),
        ),
    );
  }
}
