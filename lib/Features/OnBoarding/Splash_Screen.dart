import 'package:flutter/material.dart';
import 'package:nutri_track/Core/Utils/App_Assets.dart';
import 'package:nutri_track/core/theme/colors.dart';
import 'package:nutri_track/core/utils/app_assets.dart' hide AppAssets;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _glow = Tween<double>(begin: 0.0, end: 18.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 1700), () {
      Navigator.of(context).pushReplacementNamed('/get_started');
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            return Transform.scale(
              scale: _scale.value,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.white12, Colors.white10]),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.12),
                      blurRadius: _glow.value,
                      spreadRadius: _glow.value * 0.2,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
