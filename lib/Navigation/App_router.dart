import 'package:flutter/material.dart';
import 'package:nutri_track/Features/Auth/Sign_Up_Screen.dart';
import 'package:nutri_track/Features/OnBoarding/Splash_Screen.dart';
import 'package:nutri_track/Features/Profile/Edit_Profile_Screen.dart';
import 'package:nutri_track/Features/Profile/Settings_Screen.dart';
import 'package:nutri_track/Navigation/Bottom_Nav.dart';
import 'package:nutri_track/features/onboarding/get_started_screen.dart';
import 'package:nutri_track/features/auth/login_screen.dart';
import 'package:nutri_track/features/profile_setup/details_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/':
      case '/get_started':
        return MaterialPageRoute(builder: (_) => GetStartedScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/details':
        return MaterialPageRoute(builder: (_) => const DetailsScreen());
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainTabScreen());
      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}
