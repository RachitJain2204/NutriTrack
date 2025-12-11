import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/ring_progress.dart';

class DashboardHeader extends StatelessWidget {
  final String name;
  final int consumed;
  final int goal;
  const DashboardHeader({super.key, required this.name, required this.consumed, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Good morning,', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        ]),
      ),
      // mini ring
      RingProgress(progress: consumed / (goal == 0 ? 1 : goal), consumed: consumed, goal: goal, size: 96),
    ]);
  }
}
