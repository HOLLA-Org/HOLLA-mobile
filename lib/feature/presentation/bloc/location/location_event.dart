import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/feature/data/models/place_prediction_model.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LocationSearchChanged extends LocationEvent {
  final String query;
  const LocationSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class LocationPredictionSelected extends LocationEvent {
  final PlacePrediction prediction;
  const LocationPredictionSelected(this.prediction);

  @override
  List<Object?> get props => [prediction];
}

class LocationGetCurrent extends LocationEvent {
  const LocationGetCurrent();
}

class LocationMarkerConfirmed extends LocationEvent {
  final LatLng position;
  const LocationMarkerConfirmed(this.position);

  @override
  List<Object?> get props => [position];
}
