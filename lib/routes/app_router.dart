import 'package:go_router/go_router.dart';
import 'package:holla/presentation/screens/auth/login_screen.dart';
import 'package:holla/presentation/screens/auth/verify_screen.dart';
import 'package:holla/presentation/screens/auth/register_screen.dart';
import 'package:holla/presentation/screens/forgot_password/send_mail_screen.dart';
import 'package:holla/presentation/screens/forgot_password/verify_password_screen.dart';
import 'package:holla/presentation/screens/home/home_screen.dart';
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
        builder: (context, state) {
          final email = state.extra as String;
          return VerifyScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.sendmail,
        builder: (context, state) => const SendMailScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifypassword,
        builder: (context, state) => const VerifyPasswordScreen(),
      ),

      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
