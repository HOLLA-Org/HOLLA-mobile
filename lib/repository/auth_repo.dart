import '../models/auth_model.dart';

abstract class AuthRepository {
  Future<AuthModel> login(String emailOrUsername, String password);
  Future<AuthModel> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  );
  Future<void> verifyCode(String email, String code);
  Future<void> resendCode(String email);
  Future<void> logout();
}
