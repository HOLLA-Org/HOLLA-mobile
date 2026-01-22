class AmenityModel {
  final String id;
  final String name;
  final String icon;

  AmenityModel({required this.id, required this.name, required this.icon});

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
