import 'amenity_model.dart';
import 'hotel_model.dart';

class HotelDetailModel extends HotelModel {
  final List<AmenityModel> amenities;

  HotelDetailModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.priceHour,
    required super.priceDay,
    required super.totalRooms,
    required super.availableRooms,
    required super.rating,
    required super.ratingCount,
    required super.images,
    required super.isPopular,
    required super.isFavorite,
    required this.amenities,
  });

  factory HotelDetailModel.fromJson(Map<String, dynamic> json) {
    return HotelDetailModel(
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
      amenities:
          (json['amenities'] as List?)
              ?.map((e) => AmenityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
