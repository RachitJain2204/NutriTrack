import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/meal_card.dart';

class MealPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> meal;
  const MealPreviewScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final name = meal['name'] ?? 'Scanned Meal';
    final calories = meal['cal'] ?? 320;
    final macro = meal['macro'] ?? 'P 24 • C 28 • F 10';
    final desc = meal['desc'] ?? 'Suggested by image recognition (UI demo)';

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          MealCard(mealName: name, time: 'Now', calories: calories, macroSummary: macro, imageAsset: meal['image'] ?? ''),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.65), borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Details', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(desc, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text('Protein: 24 g', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text('Carbs: 28 g', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 6),
              Text('Fats: 10 g', style: const TextStyle(color: Colors.white70)),
            ]),
          ),
          const Spacer(),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Edit'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(onPressed: () {
              // For demo: pretend to save and go back
              Navigator.pop(context, {'saved': true});
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6ABF4B)), child: const Text('Add to Log'))),
          ]),
        ]),
      ),
    );
  }
}
