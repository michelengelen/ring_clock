import 'package:flutter/cupertino.dart';

class IconClipper extends CustomClipper<Path> {
  IconClipper();

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double width = size.width;
    final double height = size.height;

    path.moveTo(0.0, height * 0.2);
    path.lineTo(width * 0.8, height * 0.2);
    path.lineTo(width * 0.8, height);
    path.lineTo(0.0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(IconClipper oldClipper) {
    return true;
  }
}