import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RingProgress extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final int consumed;
  final int goal;
  final double size;

  const RingProgress({
    super.key,
    required this.progress,
    required this.consumed,
    required this.goal,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = '$consumed / $goal kcal';
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(
          size: Size(size, size),
          painter: _RingPainter(progress),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
          const SizedBox(height: 6),
          Text(displayText, style: TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      ]),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    final stroke = 12.0;

    final bgPaint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final progPaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -3.14 / 2,
        endAngle: 3.14 * 1.5,
        colors: [AppColors.primaryGreen, AppColors.accentOrange],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final angle = 2 * 3.141592653589793 * (progress.clamp(0.0, 1.0));
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.14 / 2, angle, false, progPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress;
}
