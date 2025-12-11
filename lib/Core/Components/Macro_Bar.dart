import 'package:flutter/material.dart';
import '../theme/colors.dart';

class MacroBar extends StatelessWidget {
  final int protein;
  final int carbs;
  final int fats;
  final int kcalGoal;

  const MacroBar({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.kcalGoal,
  });

  Widget _row(String label, int value, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 8),
      Expanded(
        child: LinearProgressIndicator(
          value: (value / (kcalGoal == 0 ? 1 : kcalGoal)).clamp(0.0, 1.0),
          backgroundColor: Colors.white12,
          color: color,
          minHeight: 8,
        ),
      ),
      const SizedBox(width: 8),
      Text('$value g', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _row('Protein', protein, AppColors.blue),
      const SizedBox(height: 8),
      _row('Carbs', carbs, AppColors.purple),
      const SizedBox(height: 8),
      _row('Fats', fats, AppColors.red),
    ]);
  }
}
