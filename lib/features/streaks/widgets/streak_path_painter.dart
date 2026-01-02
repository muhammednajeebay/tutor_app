import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class StreakPathPainter extends CustomPainter {
  final int totalNodes;
  final double nodeSpacing;
  final double amplitude;

  StreakPathPainter({
    required this.totalNodes,
    this.nodeSpacing = 140.0,
    this.amplitude = 100.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalNodes <= 1) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    // Generate points
    List<Offset> points = [];
    for (int i = 0; i < totalNodes; i++) {
      final y = size.height - 100 - (i * nodeSpacing);
      final x = centerX + amplitude * sin(i * pi / 1.8);
      points.add(Offset(x, y));
    }

    // Draw dashed line through points
    if (points.isNotEmpty) {
      for (int i = 0; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        _drawDashedLine(canvas, paint, p1, p2);
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    Path p = Path();
    p.moveTo(start.dx, start.dy);

    // Control points for S-curve
    double midY = (start.dy + end.dy) / 2;
    p.cubicTo(start.dx, midY, end.dx, midY, end.dx, end.dy);

    // Dash it
    for (ui.PathMetric measurePath in p.computeMetrics()) {
      double distance = 0.0;
      while (distance < measurePath.length) {
        canvas.drawPath(measurePath.extractPath(distance, distance + 8), paint);
        distance += 16;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
