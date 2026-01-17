class HomeModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int priceHour;
  final int priceDay;
  final int totalRooms;
  final int availableRooms;
  final double rating;
  final int ratingCount;
  final List<String> images;
  final bool isPopular;
  final bool isFavorite;

  HomeModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.priceHour,
    required this.priceDay,
    required this.totalRooms,
    required this.availableRooms,
    required this.rating,
    required this.ratingCount,
    required this.images,
    required this.isPopular,
    required this.isFavorite,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      priceHour: json['priceHour'],
      priceDay: json['priceDay'],
      totalRooms: json['totalRooms'],
      availableRooms: json['availableRooms'],
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'],
      images: List<String>.from(json['images'] ?? []),
      isPopular: json['isPopular'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  HomeModel copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? priceHour,
    int? priceDay,
    int? totalRooms,
    int? availableRooms,
    double? rating,
    int? ratingCount,
    List<String>? images,
    bool? isPopular,
    bool? isFavorite,
  }) {
    return HomeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      priceHour: priceHour ?? this.priceHour,
      priceDay: priceDay ?? this.priceDay,
      totalRooms: totalRooms ?? this.totalRooms,
      availableRooms: availableRooms ?? this.availableRooms,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      images: images ?? this.images,
      isPopular: isPopular ?? this.isPopular,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
