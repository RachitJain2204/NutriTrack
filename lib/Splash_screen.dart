// lib/SplashScreen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_track/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    // small delay to allow first frame (optional)
    await Future.delayed(const Duration(milliseconds: 150));

    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_get_started') ?? false;
    final token = prefs.getString('auth_token');

    // If logged in, navigate to app immediately.
    if (token != null && token.isNotEmpty) {
      // navigate to main app
      Navigator.pushReplacementNamed(context, '/app');
      // optionally start fetching profile in background (not blocking navigation)
      ApiService.getCurrentUser().then((data) {
        // ignore or cache result if you want
      }).catchError((_) {});
      return;
    }

    // Not logged in
    if (!seen) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Very lightweight UI so first frame appears instantly
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('NutriTrack', style: TextStyle(color: Color(0xFFE6A70B), fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF6ABF4B))),
          ],
        ),
      ),
    );
  }
}
