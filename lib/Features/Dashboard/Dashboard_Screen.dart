import 'package:flutter/material.dart';
import 'package:nutri_track/features/dashboard/dashboard_header.dart';
import 'package:nutri_track/features/dashboard/dashboard_macros.dart';
import 'package:nutri_track/features/dashboard/dashboard_stats.dart';
import 'package:nutri_track/features/dashboard/dashboard_meals.dart';
import 'package:nutri_track/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? user;
  bool loading = true;

  // Hard-coded sample values
  final int kcalGoal = 2200;
  final int kcalConsumed = 1585;
  final int protein = 78;
  final int carbs = 210;
  final int fats = 56;

  final List<Map<String, dynamic>> sampleMeals = [
    {
      'name': 'Oats with banana & almonds',
      'time': '08:30 AM',
      'cal': 420,
      'macro': 'P 18 • C 60 • F 12',
      'image': ''
    },
    {
      'name': 'Grilled Paneer Salad',
      'time': '01:10 PM',
      'cal': 520,
      'macro': 'P 28 • C 32 • F 20',
      'image': ''
    },
    {
      'name': 'Quinoa & Veg Bowl',
      'time': '07:30 PM',
      'cal': 345,
      'macro': 'P 22 • C 45 • F 8',
      'image': ''
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final data = await ApiService.getCurrentUser();
      setState(() => user = data);
    } catch (_) {
      // fallback values
      user = {
        'name': 'Tarsem',
        'weight': 72.5,
      };
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = user?['name'] ?? 'User';
    final weight = user?['weight']?.toString() ?? '72.5';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),

      // MAIN BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // HEADER
          DashboardHeader(
            name: name,
            consumed: kcalConsumed,
            goal: kcalGoal,
          ),

          const SizedBox(height: 20),

          // MACROS + RING + STATS
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DashboardMacros(
                protein: protein,
                carbs: carbs,
                fats: fats,
                kcalGoal: kcalGoal,
              ),
              const SizedBox(height: 16),
              DashboardStats(
                remaining: '${kcalGoal - kcalConsumed} kcal',
                steps: '6820',
                water: '1.5 L',
                sleep: '7.2 hrs',
              ),
            ]),
          ),

          const SizedBox(height: 20),

          // MEALS LIST
          DashboardMeals(
            meals: sampleMeals,
            onTapMeal: (meal) {
              // TODO: open meal preview screen
            },
          ),

          const SizedBox(height: 20),

          // QUICK SUGGESTIONS (unchanged, UI demo)
          Text('Quick suggestions',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          Row(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Protein Snack', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text('Greek Yogurt + Nuts',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Light Dinner', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text('Grilled Veg & Quinoa',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ]),

          const SizedBox(height: 40),
        ]),
      ),
    );
  }
}
