class AuthModel {
  final String id;
  final String username;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String? address;
  final String? locationName;

  AuthModel({
    required this.id,
    required this.username,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    this.address,
    this.locationName,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      address: json['address']?.toString(),
      locationName: json['locationName']?.toString(),
    );
  }
}
