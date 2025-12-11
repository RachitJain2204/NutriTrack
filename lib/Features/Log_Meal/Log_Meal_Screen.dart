import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/meal_card.dart';
import 'package:nutri_track/core/components/app_input_field.dart';
import 'package:nutri_track/core/components/app_button.dart';

class LogMealScreen extends StatefulWidget {
  const LogMealScreen({super.key});

  @override
  State<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends State<LogMealScreen> {
  // offline demo values and simple local "image" simulation
  final List<Map<String, dynamic>> loggedMeals = [
    {'name': 'Banana Smoothie', 'time': '09:00 AM', 'cal': 310, 'macro': 'P 8 • C 48 • F 6'},
    {'name': 'Veg Wrap', 'time': '12:45 PM', 'cal': 460, 'macro': 'P 20 • C 55 • F 16'},
  ];

  final TextEditingController _mealName = TextEditingController();
  final TextEditingController _calories = TextEditingController();
  bool saving = false;

  @override
  void dispose() {
    _mealName.dispose();
    _calories.dispose();
    super.dispose();
  }

  void _addManual() {
    final name = _mealName.text.trim();
    final cal = int.tryParse(_calories.text.trim());
    if (name.isEmpty || cal == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter name and calories')));
      return;
    }
    setState(() {
      loggedMeals.insert(0, {'name': name, 'time': 'Now', 'cal': cal, 'macro': 'P 12 • C 40 • F 10'});
      _mealName.clear();
      _calories.clear();
    });
  }

  Future<void> _simulateImageScan() async {
    // Simulation: pretend we scanned an image and return a suggested meal
    setState(() => saving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      loggedMeals.insert(0, {'name': 'Scanned: Chicken Salad', 'time': 'Now', 'cal': 380, 'macro': 'P 30 • C 12 • F 18'});
      saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Scan / upload section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.background.withOpacity(0.65), borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Snap a meal photo', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text('We will suggest macronutrients (UI demo)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(children: [
                  ElevatedButton.icon(onPressed: _simulateImageScan, icon: const Icon(Icons.camera_alt_outlined), label: saving ? const Text('Scanning...') : const Text('Scan')),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.photo_library_outlined), label: const Text('Upload')),
                ]),
              ])),
              const SizedBox(width: 12),
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/logo.png', width: 78, height: 78))
            ]),
          ),
          const SizedBox(height: 12),

          // Manual add
          Row(children: [
            Expanded(child: AppInputField(controller: _mealName, label: 'Meal name', hint: 'e.g., Fruit Bowl')),
            const SizedBox(width: 8),
            SizedBox(width: 110, child: AppInputField(controller: _calories, label: 'kcal', keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerRight, child: AppButton(label: 'Add Meal', onTap: _addManual)),

          const SizedBox(height: 14),
          const Align(alignment: Alignment.centerLeft, child: Text('Recent logged meals', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              itemCount: loggedMeals.length,
              itemBuilder: (ctx, i) {
                final m = loggedMeals[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MealCard(mealName: m['name'], time: m['time'], calories: m['cal'], macroSummary: m['macro']),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
