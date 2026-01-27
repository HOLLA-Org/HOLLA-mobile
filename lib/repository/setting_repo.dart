import '../models/user_model.dart';

abstract class SettingRepository {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateProfile({
    String? username,
    String? email,
    String? phone,
    String? address,
    String? locationName,
    double? latitude,
    double? longitude,
    String? gender,
    DateTime? dateOfBirth,
  });

  Future<UserModel> updateAvatar(String avatarUrl);
  Future<void> changepassword(String password, String newPassword);
}
