import 'package:equatable/equatable.dart';

class PlaceDetail extends Equatable {
  final String name;
  final double lat;
  final double lng;

  const PlaceDetail({required this.name, required this.lat, required this.lng});

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    final location = json['result']['geometry']['location'];
    return PlaceDetail(
      name: json['result']['name'],
      lat: location['lat'],
      lng: location['lng'],
    );
  }

  @override
  List<Object?> get props => [name, lat, lng];
}
