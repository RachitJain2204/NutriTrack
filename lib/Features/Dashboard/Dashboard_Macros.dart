import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/macro_bar.dart';

class DashboardMacros extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fats;
  final int kcalGoal;

  const DashboardMacros({super.key, required this.protein, required this.carbs, required this.fats, required this.kcalGoal});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Macros', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 8),
      MacroBar(protein: protein, carbs: carbs, fats: fats, kcalGoal: kcalGoal),
    ]);
  }
}
