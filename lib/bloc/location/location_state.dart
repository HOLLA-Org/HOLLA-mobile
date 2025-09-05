import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/models/place_detail_model.dart';
import 'package:holla/models/place_prediction_model.dart';

class LocationState {
  final bool loading;
  final String? error;
  final List<PlacePrediction> predictions;
  final PlaceDetail? selectedPlace;
  final LatLng? currentLocation;
  final LatLng? confirmedMarker;

  LocationState({
    this.loading = false,
    this.error,
    this.predictions = const [],
    this.selectedPlace,
    this.currentLocation,
    this.confirmedMarker,
  });

  LocationState copyWith({
    bool? loading,
    String? error,
    List<PlacePrediction>? predictions,
    PlaceDetail? selectedPlace,
    LatLng? currentLocation,
    LatLng? confirmedMarker,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      error: error,
      predictions: predictions ?? this.predictions,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      currentLocation: currentLocation ?? this.currentLocation,
      confirmedMarker: confirmedMarker ?? this.confirmedMarker,
    );
  }
}
