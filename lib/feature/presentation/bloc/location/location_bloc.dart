import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/feature/data/repository/location_repo.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository repository;

  LocationBloc(this.repository) : super(LocationState()) {
    on<LocationSearchChanged>(_onSearchChanged);
    on<LocationPredictionSelected>(_onPredictionSelected);
    on<LocationGetCurrent>(_onGetCurrentLocation);
    on<LocationMarkerConfirmed>(_onMarkerConfirmed);
  }

  Future<void> _onSearchChanged(
    LocationSearchChanged event,
    Emitter<LocationState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(predictions: []));
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      final results = await repository.fetchPredictions(event.query);
      emit(state.copyWith(predictions: results, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onPredictionSelected(
    LocationPredictionSelected event,
    Emitter<LocationState> emit,
  ) async {
    final pos = LatLng(event.prediction.lat, event.prediction.lng);

    emit(state.copyWith(selectedPlace: pos, predictions: [], loading: false));
  }

  Future<void> _onGetCurrentLocation(
    LocationGetCurrent event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final location = await repository.getCurrentLocation();
      emit(state.copyWith(loading: false, currentLocation: location));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onMarkerConfirmed(
    LocationMarkerConfirmed event,
    Emitter<LocationState> emit,
  ) {
    emit(state.copyWith(confirmedMarker: event.position));
  }
}
