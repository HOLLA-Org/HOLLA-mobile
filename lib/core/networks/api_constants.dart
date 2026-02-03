import 'package:holla/core/networks/base_api.dart';

class ApiConstant {
  // Auth
  static final String login = "${ApiBase.baseUrl}/auth/login";
  static final String register = "${ApiBase.baseUrl}/auth/register";
  static final String verify = "${ApiBase.baseUrl}/auth/verify";
  static final String resend = "${ApiBase.baseUrl}/auth/resend-code";
  static final String logout = "${ApiBase.baseUrl}/auth/logout";

  // Forgot Password
  static final String forgotPassword =
      "${ApiBase.baseUrl}/auth/forgot-password";
  static final String resetPassword = "${ApiBase.baseUrl}/auth/reset-password";
  static final String verifyPassword =
      "${ApiBase.baseUrl}/auth/check-validcode";

  // Profile
  static final String getUserProfile = "${ApiBase.baseUrl}/profile";
  static final String updateProfile =
      "${ApiBase.baseUrl}/profile/update-profile";
  static final String updateAvatar = "${ApiBase.baseUrl}/profile/update-avatar";
  static final String changepassword =
      "${ApiBase.baseUrl}/profile/change-password";

  // Notification
  static final String getNotification = "${ApiBase.baseUrl}/notification";
  static final String markReadNotification = "${ApiBase.baseUrl}/notification";
  static final String markAllRead =
      "${ApiBase.baseUrl}/notification/mark-all-read";
  static final String deleteNotification = "${ApiBase.baseUrl}/notification";
  static final String deleteAllNotification =
      "${ApiBase.baseUrl}/notification/remove-all";

  // Home
  static final String getAllHotels = "${ApiBase.baseUrl}/hotel";
  static final String getPopularHotels = "${ApiBase.baseUrl}/hotel/popular";
  static final String getRecommendedHotels =
      "${ApiBase.baseUrl}/hotel/recommended";
  static final String getTopRatedHotels = "${ApiBase.baseUrl}/hotel/top-rated";
  static final String getHotelByName = "${ApiBase.baseUrl}/hotel/search";

  // Favorite
  static final String getAllFavorite = '${ApiBase.baseUrl}/favorites';
  static final String addFavorite = '${ApiBase.baseUrl}/favorites';
  static final String removeFavorite = '${ApiBase.baseUrl}/favorites';

  // Booking
  static final String getHotelDetail = '${ApiBase.baseUrl}/hotel/detail';
  static final String createBooking = '${ApiBase.baseUrl}/bookings';
  static final String getBookingHistory = '${ApiBase.baseUrl}/bookings/history';

  // Payment
  static final String createPayment = '${ApiBase.baseUrl}/payment';
  static final String getAllDiscounts = '${ApiBase.baseUrl}/discount';

  // Review
  static final String getHotelReviews = '${ApiBase.baseUrl}/review';
  static final String createReview = '${ApiBase.baseUrl}/review';

  // Location
  static final String getLocations = '${ApiBase.baseUrl}/location';
  static final String getPopularLocations =
      '${ApiBase.baseUrl}/location/popular';
}
