import 'package:flutter/material.dart';
import 'package:nutri_track/Features/Analytics/Analytics_Screen.dart';
import 'package:nutri_track/Features/Dashboard/Dashboard_Screen.dart';
import 'package:nutri_track/Features/Log_Meal/Log_Meal_Screen.dart';
import 'package:nutri_track/Features/Profile/Profile_Screen.dart';
import 'package:nutri_track/core/theme/colors.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _current = 0;

  final List<Widget> _pages = const [
    DashboardScreen(),
    LogMealScreen(),
    AnalyticsScreen(),
    ProfileScreen(),
  ];

  void _onTap(int idx) {
    setState(() => _current = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _current, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, -3))],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BottomNavigationBar(
            currentIndex: _current,
            onTap: _onTap,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryGreen,
            unselectedItemColor: Colors.white70,
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_outlined), label: 'Log Meal'),
              BottomNavigationBarItem(icon: Icon(Icons.show_chart_outlined), label: 'Analytics'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
