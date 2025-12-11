import 'package:flutter/material.dart';
import 'package:nutri_track/Features/Auth/Login_Screen.dart';
import 'package:nutri_track/Features/Auth/Sign_Up_Screen.dart';
import 'package:nutri_track/Features/OnBoarding/Get_Started_Screen.dart';
import 'package:nutri_track/Features/Profile_Setup/Details_Screen.dart';
import 'package:nutri_track/Profile.dart';

void main() {
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
        // Define a consistent theme for radio buttons
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.all(const Color(0xFF6ABF4B)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Define the initial route and the available routes
      initialRoute: '/',
        routes: {
          '/': (context) => GetStartedScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/details': (context) => const DetailsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
    );
  }
}