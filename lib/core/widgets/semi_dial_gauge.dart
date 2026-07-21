import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Half-circle needle gauge used by the "GREY AREA VERDICT" card.
/// [percent] drives the needle angle (0 = far left, 100 = far right).
/// When [zoned] is true, three coloured bands (low/mid/high) are drawn,
/// matching the dark-theme mock; otherwise a plain arc is drawn to match
/// the light-theme mock.
class SemiDialGauge extends StatelessWidget {
  const SemiDialGauge({
    super.key,
    required this.percent,
    required this.needleColor,
    required this.arcColor,
    this.zoned = false,
    this.lowColor,
    this.midColor,
    this.highColor,
    this.width = 260,
  });

  final double percent; // 0..100
  final Color needleColor;
  final Color arcColor;
  final bool zoned;
  final Color? lowColor;
  final Color? midColor;
  final Color? highColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width / 2 + 12;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DialPainter(
          percent: percent,
          needleColor: needleColor,
          arcColor: arcColor,
          zoned: zoned,
          lowColor: lowColor ?? Colors.green,
          midColor: midColor ?? Colors.orange,
          highColor: highColor ?? Colors.red,
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.percent,
    required this.needleColor,
    required this.arcColor,
    required this.zoned,
    required this.lowColor,
    required this.midColor,
    required this.highColor,
  });

  final double percent;
  final Color needleColor;
  final Color arcColor;
  final bool zoned;
  final Color lowColor;
  final Color midColor;
  final Color highColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 6);
    final radius = size.width / 2 - 10;
    const strokeWidth = 16.0;

    if (zoned) {
      final bandPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      final bands = [lowColor, midColor, highColor];
      const sweepEach = math.pi / 3;
      for (var i = 0; i < 3; i++) {
        bandPaint.color = bands[i];
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          math.pi + (sweepEach * i),
          sweepEach,
          false,
          bandPaint,
        );
      }
    } else {
      final arcPaint = Paint()
        ..color = arcColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi,
        false,
        arcPaint,
      );
      // Base line
      canvas.drawLine(
        Offset(center.dx - radius - 10, center.dy),
        Offset(center.dx + radius + 10, center.dy),
        arcPaint,
      );
    }

    // Needle
    final angle = math.pi + (percent.clamp(0, 100) / 100) * math.pi;
    final needleLength = radius - (zoned ? strokeWidth : 6);
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(angle),
      center.dy + needleLength * math.sin(angle),
    );

    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);

    final hubPaint = Paint()..color = needleColor;
    canvas.drawCircle(center, 6, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) {
    return oldDelegate.percent != percent;
  }
}
