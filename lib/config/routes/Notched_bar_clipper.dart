import 'dart:ui';

import 'package:flutter/material.dart';

class NotchedBarClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchCenterX; // horizontal center of the notch
  final double cornerRadius;

  NotchedBarClipper({
    required this.notchRadius,
    required this.notchCenterX,
    this.cornerRadius = 28,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final r = cornerRadius;
    final notchR = notchRadius;
    final cx = notchCenterX;

    // Start top-left, after the corner radius
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    // Line to before the notch
    path.lineTo(cx - notchR * 1.4, 0);

    // Curve down into the notch (bite out of the bar)
    path.cubicTo(
      cx - notchR * 0.7, 0,
      cx - notchR, notchR * 1.15,
      cx, notchR * 1.15,
    );
    path.cubicTo(
      cx + notchR, notchR * 1.15,
      cx + notchR * 0.7, 0,
      cx + notchR * 1.4, 0,
    );

    // Line to top-right corner
    path.lineTo(size.width - r, 0);
    path.quadraticBezierTo(size.width, 0, size.width, r);

    // Down the right side
    path.lineTo(size.width, size.height - r);
    path.quadraticBezierTo(size.width, size.height, size.width - r, size.height);

    // Bottom edge
    path.lineTo(r, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - r);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant NotchedBarClipper old) =>
      old.notchRadius != notchRadius ||
      old.notchCenterX != notchCenterX ||
      old.cornerRadius != cornerRadius;
}