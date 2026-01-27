import 'package:holla/models/location_model.dart';
import 'package:holla/models/place_detail_model.dart';
import 'package:holla/models/place_prediction_model.dart';

class LocationState {
  final bool loading;
  final String? error;
  final List<PlacePrediction> predictions;
  final List<LocationModel> locations;
  final PlaceDetail? selectedPlace;
  final double? currentLat;
  final double? currentLng;
  final double? confirmedLat;
  final double? confirmedLng;
  final String? confirmedAddress;

  LocationState({
    this.loading = false,
    this.error,
    this.predictions = const [],
    this.locations = const [],
    this.selectedPlace,
    this.currentLat,
    this.currentLng,
    this.confirmedLat,
    this.confirmedLng,
    this.confirmedAddress,
  });

  LocationState copyWith({
    bool? loading,
    String? error,
    List<PlacePrediction>? predictions,
    List<LocationModel>? locations,
    PlaceDetail? selectedPlace,
    double? currentLat,
    double? currentLng,
    double? confirmedLat,
    double? confirmedLng,
    String? confirmedAddress,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      predictions: predictions ?? this.predictions,
      locations: locations ?? this.locations,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      confirmedLat: confirmedLat ?? this.confirmedLat,
      confirmedLng: confirmedLng ?? this.confirmedLng,
      confirmedAddress: confirmedAddress ?? this.confirmedAddress,
    );
  }
}
