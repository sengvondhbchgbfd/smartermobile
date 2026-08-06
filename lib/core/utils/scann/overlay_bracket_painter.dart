import 'package:flutter/material.dart';

class OverlayPainter extends CustomPainter {
  const OverlayPainter({required this.windowSize});
  final double windowSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = windowSize / 2;

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, cy - half), paint);
    canvas.drawRect(
      Rect.fromLTRB(0, cy + half, size.width, size.height),
      paint,
    );
    canvas.drawRect(Rect.fromLTRB(0, cy - half, cx - half, cy + half), paint);
    canvas.drawRect(
      Rect.fromLTRB(cx + half, cy - half, size.width, cy + half),
      paint,
    );
  }

  @override
  bool shouldRepaint(OverlayPainter old) => old.windowSize != windowSize;
}

////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////

class BracketPainter extends CustomPainter {
  const BracketPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const len = 30.0;
    final w = size.width;
    final h = size.height;

    canvas.drawLine(const Offset(0, len), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), paint);
    canvas.drawLine(Offset(w - len, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, len), paint);
    canvas.drawLine(Offset(0, h - len), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(len, h), paint);
    canvas.drawLine(Offset(w - len, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h - len), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(BracketPainter old) => old.color != color;
}
