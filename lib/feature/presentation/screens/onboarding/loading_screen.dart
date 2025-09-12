import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/config/routes/app_routes.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  // Controls the fade animation.
  late AnimationController _animationController;
  // Drives the opacity for the fade.
  late Animation<double> _animation;

  // Timer for the dot animation.
  Timer? _timer;
  // Tracks the number of dots.
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();

    // Set up the fade animation to pulse.
    _setupFadeAnimation();

    // Set up the timer for the dot animation.
    _setupDotAnimation();

    // Navigate to the login screen after a delay.
    _navigateToLogin();
  }

  void _setupFadeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _setupDotAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount % 3) + 1;
        });
      }
    });
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    // Clean up resources to prevent memory leaks.
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create the animated dots string.
    String dots = '.'.padRight(_dotCount, '.');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo
              const Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Image(
                    image: AssetImage('assets/logos/loading.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Apply fade animation.
              FadeTransition(
                opacity: _animation,
                child: Text(
                  'Đang tải {{dots}}'.tr(namedArgs: {'dots': dots}),
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'CrimsonText',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
