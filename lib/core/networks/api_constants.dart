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
}
