class LocationModel {
  final String id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isPopular;

  LocationModel({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.isPopular = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isPopular': isPopular,
    };
  }
}
