class UserInfo {
  final String id;
  final String username;
  final String? avatarUrl;

  UserInfo({required this.id, required this.username, this.avatarUrl});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      username: json['username'] ?? 'Ẩn danh',
      avatarUrl: json['avatarUrl'],
    );
  }
}
