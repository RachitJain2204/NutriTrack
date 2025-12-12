// lib/main.dart
import 'package:flutter/material.dart';
import 'package:nutri_track/Main_Nav_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_track/Get_Started_Screen.dart';
import 'package:nutri_track/Login%20and%20Sign%20Up/Login_Screen.dart';
import 'package:nutri_track/Login%20and%20Sign%20Up/Sign_Up_Screen.dart';
import 'package:nutri_track/Details_Screen.dart';
import 'package:nutri_track/Profile.dart';
import 'package:nutri_track/Meal_Screen.dart';
import 'package:nutri_track/Splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriTrack',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE6A70B),
        radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all(const Color(0xFF6ABF4B))),
      ),
      debugShowCheckedModeBanner: false,
      // Start instantly on SplashScreen which will redirect quickly
      initialRoute: '/splash',
      routes: {
        '/splash': (c) => const SplashScreen(),
        '/': (c) => GetStartedScreen(),
        '/login': (c) => const LoginScreen(),
        '/signup': (c) => const SignUpScreen(),
        '/details': (c) => const DetailsScreen(),
        '/profile': (c) => const ProfileScreen(),
        '/meal': (c) => const FoodImageUploadScreen(),
        '/app': (c) => const MainNavScreen(),
      },
    );
  }
}
