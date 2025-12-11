import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/stat_card.dart';

class DashboardStats extends StatelessWidget {
  final String remaining;
  final String steps;
  final String water;
  final String sleep;

  const DashboardStats({super.key, required this.remaining, required this.steps, required this.water, required this.sleep});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: StatCard(title: 'Remaining', value: remaining, icon: Icons.local_fire_department)),
      const SizedBox(width: 10),
      Expanded(child: StatCard(title: 'Steps', value: steps, icon: Icons.directions_walk)),
    ]);
  }
}
