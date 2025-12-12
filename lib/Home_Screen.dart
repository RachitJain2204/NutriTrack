// lib/Home_Screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nutri_track/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _nutriGreen = const Color(0xFF6ABF4B);

  // Hardcoded sample values (as requested)
  final int totalCalories = 2000;
  final int consumedCalories = 1100;

  // macronutrient sample targets and consumed
  final double carbsTarget = 300; // grams
  final double carbsConsumed = 180;

  final double proteinTarget = 90;
  final double proteinConsumed = 50;

  final double fatTarget = 70;
  final double fatConsumed = 30;

  late Future<Map<String, dynamic>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = ApiService.getCurrentUser();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 22) return 'Good Evening';
    return 'Hello';
  }

  Widget _buildHeader(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          // left side greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting(),
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here is your daily progress',
                  style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 12),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              children: [
                Text('Goal', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                const SizedBox(height: 6),
                Text('${totalCalories} kcal', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaloriePie() {
    final remaining = (totalCalories - consumedCalories).clamp(0, totalCalories).toDouble();
    final consumed = consumedCalories.toDouble();
    final fractionRemaining = (remaining / totalCalories).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Calories', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, fontWeight: FontWeight.w600)),
              Text('Today', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(180, 180),
                  painter: _CaloriePiePainter(
                    fractionRemaining: fractionRemaining,
                    remainingColor: _nutriGreen,
                    consumedColor: Colors.white12,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${remaining.toInt()} / $totalCalories',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text('kcal left', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendDot(_nutriGreen, 'Remaining ${remaining.toInt()}'),
              _legendDot(Colors.white12, 'Consumed ${consumedCalories.toInt()}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.white.withOpacity(0.85))),
      ],
    );
  }

  Widget _buildBackwardBar({
    required String title,
    required double target,
    required double consumed,
    required Color color,
  }) {
    final remaining = (target - consumed).clamp(0.0, target);
    final fraction = target > 0 ? remaining / target : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label and numbers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
              Text('${remaining.toInt()} / ${target.toInt()} left', style: TextStyle(color: Colors.white.withOpacity(0.85))),
            ],
          ),
          const SizedBox(height: 8),
          // bar background
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calRemaining = (totalCalories - consumedCalories).clamp(0, totalCalories).toInt();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('NutriTrack'),
        backgroundColor: _nutriGreen,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userFuture,
        builder: (context, snap) {
          String name = 'User';
          if (snap.hasData) {
            final user = snap.data!;
            name = (user['name'] ?? user['username'] ?? 'User').toString();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(name),
                    const SizedBox(height: 16),
                    _buildCaloriePie(),
                    const SizedBox(height: 16),
                    _buildBackwardBar(
                      title: 'Carbohydrates',
                      target: carbsTarget,
                      consumed: carbsConsumed,
                      color: Colors.blueAccent.shade200,
                    ),
                    const SizedBox(height: 12),
                    _buildBackwardBar(
                      title: 'Protein',
                      target: proteinTarget,
                      consumed: proteinConsumed,
                      color: Colors.orangeAccent.shade200,
                    ),
                    const SizedBox(height: 12),
                    _buildBackwardBar(
                      title: 'Fat',
                      target: fatTarget,
                      consumed: fatConsumed,
                      color: Colors.pinkAccent.shade200,
                    ),
                    const SizedBox(height: 26),
                    // (Log food button removed as requested)
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter that draws a two-color pie (remaining and consumed).
class _CaloriePiePainter extends CustomPainter {
  final double fractionRemaining; // 0..1 (remaining / total)
  final Color remainingColor;
  final Color consumedColor;

  _CaloriePiePainter({
    required this.fractionRemaining,
    required this.remainingColor,
    required this.consumedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double stroke = 0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - stroke;

    final Paint backgroundPaint = Paint()
      ..color = consumedColor
      ..style = PaintingStyle.fill;

    final Paint remainingPaint = Paint()
      ..color = remainingColor
      ..style = PaintingStyle.fill;

    // draw full consumed circle as background
    canvas.drawCircle(center, radius, backgroundPaint);

    // draw remaining arc (starting from top -90deg)
    final double sweep = (fractionRemaining * 2 * math.pi).clamp(0.0, 2 * math.pi);
    final double start = -math.pi / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    if (sweep > 0) {
      canvas.drawArc(rect, start, sweep, true, remainingPaint);
    }

    // inner cutout to mimic centerSpaceRadius
    final double innerRadius = radius * 0.55;
    final Paint innerPaint = Paint()..color = Colors.grey.shade900;
    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _CaloriePiePainter oldDelegate) {
    return oldDelegate.fractionRemaining != fractionRemaining ||
        oldDelegate.remainingColor != remainingColor ||
        oldDelegate.consumedColor != consumedColor;
  }
}
