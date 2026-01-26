import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 180),

              // Logo
              Expanded(
                flex: 9,
                child: Center(
                  child: Image(
                    image: AssetImage('assets/logos/splash.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),

              // Title
              Text(
                'HoLLa',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008080),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'common.from'.tr(),
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 28,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ming',
                    style: TextStyle(
                      fontFamily: 'Caveat',
                      fontSize: 36,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
