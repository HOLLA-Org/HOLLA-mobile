class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? address;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;

  const UserModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.address,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      dateOfBirth:
          json['date_of_birth'] != null
              ? DateTime.tryParse(json['date_of_birth'])
              : null,
    );
  }
}
