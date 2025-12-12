import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_track/Details_Screen.dart';
import 'package:nutri_track/Login%20and%20Sign%20Up/Login_Screen.dart';
import 'package:nutri_track/Get_Started_Screen.dart';
import 'package:nutri_track/Login%20and%20Sign%20Up/Sign_Up_Screen.dart';
import 'package:nutri_track/Meal_Screen.dart';
import 'package:nutri_track/Profile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> _decideStartup() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_get_started') ?? false;
    final token = prefs.getString('auth_token');
    // return a small map that the FutureBuilder will use
    return {
      'seen': seen,
      'token': token,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE6A70B),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xFF6ABF4B)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // we'll use home and a FutureBuilder to decide which screen to show
      home: FutureBuilder<Map<String, dynamic>>(
        future: _decideStartup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final data = snapshot.data ?? {};
          final bool seen = data['seen'] ?? false;
          final String? token = data['token'];

          if (!seen) {
            return GetStartedScreen();
          }

          if (token != null && token.isNotEmpty) {
            return const FoodImageUploadScreen();
          }

          return const LoginScreen();
        },
      ),
      routes: {
        '/': (context) => GetStartedScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/details': (context) => const DetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/meal': (context) => const FoodImageUploadScreen(),
      },
    );
  }
}