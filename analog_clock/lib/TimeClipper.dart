import 'package:flutter/cupertino.dart';

class TimeClipper extends CustomClipper<Path> {
  TimeClipper({
    @required this.edge
  });

  clippingEdges edge;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;
    final double clippingAmount = height / 3;
    switch (edge) {
      case clippingEdges.BOTTOM_LEFT:
        path.lineTo(width * 1.5, 0.0);
        path.lineTo(width * 1.5, height);
        path.lineTo(width - clippingAmount, height);
        path.close();
        break;
      case clippingEdges.BOTTOM_RIGHT:
        path.lineTo(width, 0.0);
        path.lineTo(width - clippingAmount, height);
        path.lineTo(-width, height);
        path.lineTo(-width, 0.0);
        path.close();
        break;
      case clippingEdges.TOP_LEFT:
        path.moveTo(clippingAmount, 0.0);
        path.lineTo(width, 0.0);
        path.lineTo(width, height);
        path.lineTo(0.0, height);
        path.close();
        break;
      case clippingEdges.TOP_RIGHT:
        path.lineTo(width - clippingAmount, 0.0);
        path.lineTo(width, height);
        path.lineTo(0.0, height);
        path.close();
        break;
      default:
    }
    return path;
  }

  @override
  bool shouldReclip(TimeClipper oldClipper) {
    return true;
  }
}

enum clippingEdges {
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  TOP_LEFT,
  TOP_RIGHT,
}