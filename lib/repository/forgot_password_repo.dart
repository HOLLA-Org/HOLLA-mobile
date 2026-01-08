abstract class ForgotPasswordRepository {
  Future<void> sendMail(String email);

  Future<String> verifyPassword(String email, String code);

  Future<void> resendCode(String email);

  Future<void> resetPassword(String token, String newPassword);
}
