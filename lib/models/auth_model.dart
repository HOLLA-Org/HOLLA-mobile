class AuthModel {
  final String id;
  final String username;
  final String email;

  AuthModel({required this.id, required this.username, required this.email});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }
}
