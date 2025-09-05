import 'package:equatable/equatable.dart';

class PlacePrediction extends Equatable {
  final String placeId;
  final String description;

  const PlacePrediction({required this.placeId, required this.description});

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'],
      description: json['description'],
    );
  }

  @override
  List<Object?> get props => [placeId, description];
}
