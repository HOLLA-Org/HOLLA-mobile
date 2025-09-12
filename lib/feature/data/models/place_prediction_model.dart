import 'package:equatable/equatable.dart';

class PlacePrediction extends Equatable {
  final String placeId;
  final String description;
  final double lat;
  final double lng;

  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.lat,
    required this.lng,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['osm_id'].toString(),
      description: json['display_name'] ?? '',
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lng: double.tryParse(json['lon'].toString()) ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [placeId, description, lat, lng];
}
