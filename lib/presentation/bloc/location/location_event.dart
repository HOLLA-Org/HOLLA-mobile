import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final LatLng position;
  LocationMarkerConfirmed(this.position);
}
