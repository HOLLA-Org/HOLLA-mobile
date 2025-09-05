import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/repository/location_repo.dart';
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
      emit(LocationState(predictions: [], selectedPlace: state.selectedPlace));
      return;
    }

    emit(
      LocationState(
        predictions: state.predictions,
        selectedPlace: state.selectedPlace,
        loading: true,
      ),
    );

    try {
      final results = await repository.fetchPredictions(event.query);
      emit(
        LocationState(predictions: results, selectedPlace: state.selectedPlace),
      );
    } catch (e) {
      emit(
        LocationState(
          predictions: state.predictions,
          selectedPlace: state.selectedPlace,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPredictionSelected(
    LocationPredictionSelected event,
    Emitter<LocationState> emit,
  ) async {
    emit(
      LocationState(
        predictions: state.predictions,
        selectedPlace: state.selectedPlace,
        loading: true,
      ),
    );

    try {
      final detail = await repository.fetchPlaceDetail(event.placeId);
      emit(
        LocationState(predictions: state.predictions, selectedPlace: detail),
      );
    } catch (e) {
      emit(
        LocationState(
          predictions: state.predictions,
          selectedPlace: state.selectedPlace,
          error: e.toString(),
        ),
      );
    }
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
