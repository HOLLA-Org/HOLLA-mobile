import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationSearchChanged extends LocationEvent {
  final String query;
  LocationSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class LocationPredictionSelected extends LocationEvent {
  final String placeId;
  LocationPredictionSelected(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class LocationGetCurrent extends LocationEvent {}

class LocationMarkerConfirmed extends LocationEvent {
  final double lat;
  final double lng;
  final String address;

  LocationMarkerConfirmed({
    required this.lat,
    required this.lng,
    required this.address,
  });

  @override
  List<Object?> get props => [lat, lng, address];
}

class LocationMarkerMoved extends LocationEvent {
  final double lat;
  final double lng;

  LocationMarkerMoved(this.lat, this.lng);

  @override
  List<Object?> get props => [lat, lng];
}

class LocationFetchAll extends LocationEvent {}
