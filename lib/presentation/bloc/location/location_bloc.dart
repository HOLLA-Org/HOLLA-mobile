import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/repository/location_repo.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc({required LocationRepository locationRepository})
    : _locationRepository = locationRepository,
      super(LocationState()) {
    on<LocationSearchChanged>(_onSearchChanged);
    on<LocationPredictionSelected>(_onPredictionSelected);
    on<LocationGetCurrent>(_onGetCurrentLocation);
    on<LocationMarkerConfirmed>(_onMarkerConfirmed);
    on<LocationMarkerMoved>(_onMarkerMoved);
    on<LocationFetchAll>(_onFetchAll);
  }

  Future<void> _onMarkerMoved(
    LocationMarkerMoved event,
    Emitter<LocationState> emit,
  ) async {
    try {
      String address = "Vị trí đã chọn";
      final suggestions = await _locationRepository.fetchPredictionsByLocation(
        event.lng.toString(),
        event.lat,
        event.lng,
      );

      if (suggestions.isNotEmpty) {
        address = suggestions.first.description;
      } else {
        address = await _locationRepository.reverseGeocode(
          event.lat,
          event.lng,
        );
      }

      emit(
        state.copyWith(
          confirmedLat: event.lat,
          confirmedLng: event.lng,
          confirmedAddress: address,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFetchAll(
    LocationFetchAll event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final locations = await _locationRepository.getLocations();
      emit(state.copyWith(loading: false, locations: locations));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onSearchChanged(
    LocationSearchChanged event,
    Emitter<LocationState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(LocationState(predictions: [], selectedPlace: state.selectedPlace));
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      final results = await _locationRepository.fetchPredictions(event.query);
      emit(state.copyWith(loading: false, predictions: results));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onPredictionSelected(
    LocationPredictionSelected event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    try {
      final detail = await _locationRepository.fetchPlaceDetail(event.placeId);
      emit(state.copyWith(loading: false, selectedPlace: detail));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onGetCurrentLocation(
    LocationGetCurrent event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final location = await _locationRepository.getCurrentLocation();
      if (location != null) {
        emit(
          state.copyWith(
            loading: false,
            currentLat: location.latitude,
            currentLng: location.longitude,
          ),
        );
      } else {
        // Fallback to Hanoi if cannot get current location
        emit(
          state.copyWith(
            loading: false,
            currentLat: 21.0285,
            currentLng: 105.8542,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          currentLat: 21.0285,
          currentLng: 105.8542,
          error: e.toString(),
        ),
      );
    }
  }

  void _onMarkerConfirmed(
    LocationMarkerConfirmed event,
    Emitter<LocationState> emit,
  ) {
    emit(
      state.copyWith(
        confirmedLat: event.lat,
        confirmedLng: event.lng,
        confirmedAddress: event.address,
      ),
    );
  }
}
