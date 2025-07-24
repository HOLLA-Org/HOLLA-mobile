class ForgotPasswordModel {
  final String email;
  final String code;
  final String token;
  final String newPassword;
  final String confirmPassword;

  ForgotPasswordModel({
    required this.email,
    required this.code,
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      email: json['email']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      newPassword: json['newPassword']?.toString() ?? '',
      confirmPassword: json['confirmPassword']?.toString() ?? '',
    );
  }
}
