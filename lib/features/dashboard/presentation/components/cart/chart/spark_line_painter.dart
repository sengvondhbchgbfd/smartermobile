import 'package:flutter/material.dart';

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  const SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs() < 0.001 ? 1.0 : max - min;
    final step = size.width / (data.length - 1);

    final points = List.generate(data.length, (i) {
      final x = i * step;
      final y = size.height - ((data[i] - min) / range) * size.height;
      return Offset(x, y);
    });

    final fillPath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) fillPath.lineTo(p.dx, p.dy);
    fillPath
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.25), color.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) linePath.lineTo(p.dx, p.dy);
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(SparklinePainter old) =>
      old.data != data || old.color != color;
}
