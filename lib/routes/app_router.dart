import 'package:go_router/go_router.dart';
import 'package:holla/presentation/screens/auth/login_sreen.dart';
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
        path: AppRoutes.login,
        builder: (context, state) => const LoginSreen(),
      ),
    ],
  );
}
