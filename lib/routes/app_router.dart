import 'package:go_router/go_router.dart';
import 'package:holla/presentation/screens/auth/login_screen.dart';
import 'package:holla/presentation/screens/auth/verify_screen.dart';
import 'package:holla/presentation/screens/auth/register_screen.dart';
import 'package:holla/presentation/screens/onboarding/loading_screen.dart';
import 'package:holla/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:holla/presentation/screens/onboarding/splash_screen.dart';
import 'package:holla/routes/app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Route don't have nav bar
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.verify,
        builder: (context, state) => const VerifyScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
