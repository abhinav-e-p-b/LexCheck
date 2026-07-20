import 'package:flutter/material.dart';

/// Circular progress ring used by the "SAFETY PROFILE" card, showing a
/// percentage value in the middle (e.g. "82 / OPTIMAL").
class RingGauge extends StatelessWidget {
  const RingGauge({
    super.key,
    required this.percent,
    required this.trackColor,
    required this.progressColor,
    required this.centerText,
    required this.centerSubText,
    required this.textColor,
    this.size = 120,
    this.strokeWidth = 10,
  });

  final double percent; // 0..100
  final Color trackColor;
  final Color progressColor;
  final String centerText;
  final String centerSubText;
  final Color textColor;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              percent: percent,
              trackColor: trackColor,
              progressColor: progressColor,
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              Text(
                centerSubText,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  color: textColor.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.percent,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double percent;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    const startAngle = -90 * 3.14159265 / 180;
    final sweepAngle = (percent.clamp(0, 100) / 100) * 2 * 3.14159265;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
