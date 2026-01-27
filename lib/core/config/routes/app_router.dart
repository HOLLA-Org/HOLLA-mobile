import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/screens/booking/booking_detail_screen.dart';
import 'package:holla/presentation/screens/home/search_screen.dart';
import 'package:holla/presentation/screens/home/view_all_screen.dart';
import 'package:holla/presentation/screens/setting/take_camera_page.dart';
import 'package:holla/presentation/widget/navigation/custom_bottom_navigation.dart';
import 'package:holla/presentation/screens/auth/login_screen.dart';
import 'package:holla/presentation/screens/auth/verify_screen.dart';
import 'package:holla/presentation/screens/auth/register_screen.dart';
import 'package:holla/presentation/screens/booking_history/booking_history_screen.dart';
import 'package:holla/presentation/screens/favorite/favorite_screen.dart';
import 'package:holla/presentation/screens/forgot_password/reset_password_screen.dart';
import 'package:holla/presentation/screens/forgot_password/send_mail_screen.dart';
import 'package:holla/presentation/screens/forgot_password/verify_password_screen.dart';
import 'package:holla/presentation/screens/home/home_screen.dart';
import 'package:holla/presentation/screens/map/google_map_screen.dart';
import 'package:holla/presentation/screens/onboarding/loading_screen.dart';
import 'package:holla/presentation/screens/onboarding/location_permission_screen.dart';
import 'package:holla/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:holla/presentation/screens/onboarding/select_location_screen.dart';
import 'package:holla/presentation/screens/onboarding/splash_screen.dart';
import 'package:holla/presentation/screens/setting/select_language_screen.dart';
import 'package:holla/presentation/screens/setting/change_password_screen.dart';
import 'package:holla/presentation/screens/setting/change_profile_screen.dart';
import 'package:holla/presentation/screens/setting/setting_screen.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/models/hotel_detail_model.dart';

import 'package:holla/presentation/screens/booking/booking_time_screen.dart';
import 'package:holla/presentation/screens/payment/payment_screen.dart';
import 'package:holla/presentation/screens/payment/payment_args.dart';
import 'package:holla/presentation/screens/review/review_screen.dart';
import 'package:holla/models/review_model.dart';
import '../../../presentation/screens/home/view_all_args.dart';
import '../../../presentation/screens/notification/notification_screen.dart';
import '../../../presentation/screens/review/write_review_screen.dart';

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
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.language,
        builder: (context, state) => const SelectLanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.googlemap,
        builder: (context, state) => const GoogleMapScreen(),
      ),
      GoRoute(
        path: AppRoutes.changepassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.changeprofile,
        builder: (context, state) => const ChangeProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.takecamera,
        builder: (context, state) => const TakeCameraPage(),
      ),

      // Home
      GoRoute(
        path: AppRoutes.viewall,
        builder: (context, state) {
          final args = state.extra as ViewAllArgs;
          return ViewAllScreen(title: args.title, hotels: args.hotels);
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) {
          final name = state.extra as String;
          return SearchScreen(name: name);
        },
      ),

      // Booking Detail
      GoRoute(
        path: AppRoutes.bookingdetail,
        builder: (context, state) {
          final hotelId = state.extra as String;
          return BookingDetailScreen(hotelId: hotelId);
        },
      ),

      // Booking
      GoRoute(
        path: AppRoutes.bookingtime,
        builder: (context, state) {
          final hotel = state.extra as HotelDetailModel;
          return BookingTimeScreen(hotel: hotel);
        },
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) {
          final args = state.extra as PaymentArgs;
          return PaymentScreen(args: args);
        },
      ),

      // Review
      GoRoute(
        path: AppRoutes.review,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ReviewScreen(
            reviews: args['reviews'] as List<ReviewModel>,
            rating: args['rating'] as double,
            ratingCount: args['ratingCount'] as int,
          );
        },
      ),

      GoRoute(
        path: AppRoutes.writereview,
        builder: (context, state) {
          final bookingId = state.extra as String;
          return WriteReviewScreen(bookingId: bookingId);
        },
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
            path: AppRoutes.bookinghistory,
            builder: (context, state) => const BookingHistoryScreen(),
          ),
          GoRoute(
            path: AppRoutes.setting,
            builder: (context, state) => const SettingScreen(),
          ),
        ],
      ),
    ],
  );
  static int _getNavIndex(String path) {
    if (path.startsWith(AppRoutes.home)) return 0;
    if (path.startsWith(AppRoutes.favorite)) return 1;
    if (path.startsWith(AppRoutes.bookinghistory)) return 2;
    if (path.startsWith(AppRoutes.setting)) return 3;
    return 0;
  }
}
