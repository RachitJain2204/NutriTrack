import 'package:flutter/material.dart';
import 'Get_Started_Screen.dart';

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
      },
    );
  }
}