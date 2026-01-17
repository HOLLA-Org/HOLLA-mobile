import 'package:holla/core/networks/base_api.dart';

class ApiConstant {
  // Auth
  static const String login = "${ApiBase.baseUrl}/auth/login";
  static const String register = "${ApiBase.baseUrl}/auth/register";
  static const String verify = "${ApiBase.baseUrl}/auth/verify";
  static const String resend = "${ApiBase.baseUrl}/auth/resend-code";
  static const String logout = "${ApiBase.baseUrl}/auth/logout";

  // Forgot Password
  static const String forgotPassword =
      "${ApiBase.baseUrl}/auth/forgot-password";
  static const String resetPassword = "${ApiBase.baseUrl}/auth/reset-password";
  static const String verifyPassword =
      "${ApiBase.baseUrl}/auth/check-validcode";

  // Profile
  static const String getUserProfile = "${ApiBase.baseUrl}/profile";
  static const String updateProfile =
      "${ApiBase.baseUrl}/profile/update-profile";
  static const String updateAvatar = "${ApiBase.baseUrl}/profile/update-avatar";
  static const String changepassword =
      "${ApiBase.baseUrl}/profile/change-password";

  // Notification
  static const String getNotification = "${ApiBase.baseUrl}/notification";
  static const String markReadNotification = "${ApiBase.baseUrl}/notification";
  static const String markAllRead =
      "${ApiBase.baseUrl}/notification/mark-all-read";
  static const String deleteNotification = "${ApiBase.baseUrl}/notification";
  static const String deleteAllNotification =
      "${ApiBase.baseUrl}/notification/remove-all";

  // Home
  static const String getAllHotels = "${ApiBase.baseUrl}/hotel";
  static const String getPopularHotels = "${ApiBase.baseUrl}/hotel/popular";
  static const String getRecommendedHotels =
      "${ApiBase.baseUrl}/hotel/recommended";
  static const String getTopRatedHotels = "${ApiBase.baseUrl}/hotel/top-rated";
  static const String getHotelByName = "${ApiBase.baseUrl}/hotel/search";

  // Favorite
  static const String getFavoriteIds = '${ApiBase.baseUrl}/favorites/ids';
  static const String addFavorite = '${ApiBase.baseUrl}/favorites';
  static const String removeFavorite = '${ApiBase.baseUrl}/favorites';
}
