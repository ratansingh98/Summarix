import 'dart:math';

import 'package:flutter/material.dart';

class DottedCircle extends StatelessWidget {
  const DottedCircle({super.key, required this.diameter, required this.child});

  final double diameter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedCirclePainter(),
      child: SizedBox(
        height: diameter,
        width: diameter,
        child: Center(child: child),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF86B6CE)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashLength = 6.0;
    const gapLength = 6.0;
    final radius = size.width / 2;
    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();
    final sweep = (2 * pi) / dashCount;

    for (var i = 0; i < dashCount; i++) {
      final startAngle = i * sweep;
      canvas.drawArc(
        Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
        startAngle,
        sweep * 0.6,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
