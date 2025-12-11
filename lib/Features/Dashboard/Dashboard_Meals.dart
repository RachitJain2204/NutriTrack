import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/meal_card.dart';

class DashboardMeals extends StatelessWidget {
  final List<Map<String, dynamic>> meals;
  final void Function(Map<String, dynamic>)? onTapMeal;

  const DashboardMeals({super.key, required this.meals, this.onTapMeal});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Meals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      Column(
        children: meals.map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: MealCard(
              mealName: m['name'] ?? '-',
              time: m['time'] ?? '-',
              calories: m['cal'] ?? 0,
              macroSummary: m['macro'] ?? '-',
              imageAsset: m['image'] ?? '',
              onTap: () {
                if (onTapMeal != null) onTapMeal!(m);
              },
            ),
          );
        }).toList(),
      )
    ]);
  }
}
