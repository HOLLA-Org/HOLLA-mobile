import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/feature/presentation/navigation/custom_bottom_navigation.dart';
import 'package:holla/feature/presentation/screens/auth/login_screen.dart';
import 'package:holla/feature/presentation/screens/auth/verify_screen.dart';
import 'package:holla/feature/presentation/screens/auth/register_screen.dart';
import 'package:holla/feature/presentation/screens/booking/booking_screen.dart';
import 'package:holla/feature/presentation/screens/favorite/favorite_screen.dart';
import 'package:holla/feature/presentation/screens/forgot_password/reset_password_screen.dart';
import 'package:holla/feature/presentation/screens/forgot_password/send_mail_screen.dart';
import 'package:holla/feature/presentation/screens/forgot_password/verify_password_screen.dart';
import 'package:holla/feature/presentation/screens/home/home_screen.dart';
import 'package:holla/feature/presentation/screens/map/google_map_screen.dart';
import 'package:holla/feature/presentation/screens/onboarding/loading_screen.dart';
import 'package:holla/feature/presentation/screens/onboarding/location_permission_screen.dart';
import 'package:holla/feature/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:holla/feature/presentation/screens/onboarding/select_location_screen.dart';
import 'package:holla/feature/presentation/screens/onboarding/splash_screen.dart';
import 'package:holla/feature/presentation/screens/profile/profile_screen.dart';
import 'package:holla/feature/presentation/screens/setting/%20select_language_screen.dart';
import 'package:holla/config/routes/app_routes.dart';

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
        path: AppRoutes.locationpermission,
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: AppRoutes.selectlocation,
        builder: (context, state) => const SelectLocationScreen(),
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
        builder: (context, state) {
          final email = state.extra as String;
          return VerifyPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.resetpassword,
        builder: (context, state) {
          final token = state.extra as String;
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: AppRoutes.notification,
        builder: (context, state) => const SendMailScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const SelectLanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.googlemap,
        builder: (context, state) => const GoogleMapScreen(),
      ),

      // ShellRoute have nav bar
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = _getNavIndex(state.uri.path);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomBottomNavBar(initialIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.favorite,
            builder: (context, state) => FavoriteScreen(),
          ),
          GoRoute(
            path: AppRoutes.booking,
            builder: (context, state) => const BookingScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
  static int _getNavIndex(String path) {
    if (path.startsWith(AppRoutes.favorite)) return 1;
    if (path.startsWith(AppRoutes.booking)) return 2;
    if (path.startsWith(AppRoutes.profile)) return 3;
    if (path.startsWith(AppRoutes.setting)) return 4;
    return 0;
  }
}
