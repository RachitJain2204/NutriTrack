// lib/MainNavScreen.dart
import 'package:flutter/material.dart';
import 'package:nutri_track/Home_Screen.dart';
import 'package:nutri_track/Profile.dart';
import 'package:nutri_track/Meal_Screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({Key? key}) : super(key: key);

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;
  final Color _nutriGreen = const Color(0xFF6ABF4B);

  // Pages: 0 = Home, 1 = Meal Split (placeholder -> profile for now),
  // 2 = Log Meal, 3 = Weekly Tracker (placeholder -> profile for now)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),              // 1st - Home
      const ProfileScreen(),           // 2nd - placeholder (you said map to profile for now)
      const FoodImageUploadScreen(),   // 3rd - Log Meal screen (your meal upload)
      const ProfileScreen(),           // 4th - Weekly tracker placeholder -> profile for now
    ];
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We don't show AppBar here because HomeScreen and other pages have their own appbar.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: _nutriGreen,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTap,
        items: [
          _navItem(Icons.home_outlined, 'Home'),
          _navItem(Icons.restaurant_menu_outlined, 'Meals'),
          _navItem(Icons.add_box_outlined, 'Log Meal'),
          _navItem(Icons.show_chart_outlined, 'Weekly'),
        ],
      ),
    );
  }
}
