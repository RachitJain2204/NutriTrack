import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/stat_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  // Hard-coded weekly data (calories)
  final List<int> weekCalories = const [2180, 2000, 1900, 2400, 2200, 1585, 1750];

  @override
  Widget build(BuildContext context) {
    final maxCal = weekCalories.reduce((a, b) => a > b ? a : b);
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: const [
            Expanded(child: StatCard(title: 'Avg calories', value: '2067 kcal', icon: Icons.show_chart)),
            SizedBox(width: 12),
            Expanded(child: StatCard(title: 'Avg protein', value: '78 g', icon: Icons.fitness_center)),
          ]),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.65), borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Last 7 days', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              // simple bar chart substitute
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: weekCalories.map((c) {
                final height = (c / (maxCal == 0 ? 1 : maxCal)) * 120;
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(height: height, margin: const EdgeInsets.symmetric(horizontal: 6), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6ABF4B), Color(0xFFE6A70B)]), borderRadius: BorderRadius.circular(8))),
                      const SizedBox(height: 6),
                      Text('${(weekCalories.indexOf(c) == 0) ? 'Mon' : (weekCalories.indexOf(c) == 1) ? 'Tue' : (weekCalories.indexOf(c) == 2) ? 'Wed' : (weekCalories.indexOf(c) == 3) ? 'Thu' : (weekCalories.indexOf(c) == 4) ? 'Fri' : (weekCalories.indexOf(c) == 5) ? 'Sat' : 'Sun'}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                );
              }).toList()),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('Weight trend', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          // simple trend line substitute - dots and polyline-like visual using containers
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.65), borderRadius: BorderRadius.circular(18)),
            child: Center(child: Text('Weight chart preview (UI only)', style: TextStyle(color: Colors.white70))),
          ),
        ]),
      ),
    );
  }
}
