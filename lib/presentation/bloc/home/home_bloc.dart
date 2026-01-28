import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/models/hotel_model.dart';

import 'home_event.dart';
import 'home_state.dart';
import '../../../repository/home_repo.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeInitial()) {
    on<GetAllHotels>(_onGetAllHotels);
    on<GetPopularHotels>(_onGetPopularHotels);
    on<GetRecommendedHotels>(_onGetRecommendedHotels);
    on<GetTopRatedHotels>(_onGetTopRatedHotels);
    on<ToggleFavoriteLocal>(_onToggleFavoriteLocal);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onGetAllHotels(
    GetAllHotels event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.getAllHotels(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final hotels = results[0] as List<HotelModel>;
      emit(GetAllHotelsSuccess(hotels));
    } catch (e) {
      emit(HomeFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onGetPopularHotels(
    GetPopularHotels event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.getPopularHotels(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final hotels = results[0] as List<HotelModel>;
      emit(GetPopularHotelsSuccess(hotels));
    } catch (e) {
      emit(HomeFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onGetRecommendedHotels(
    GetRecommendedHotels event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.getRecommendedHotels(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final hotels = results[0] as List<HotelModel>;
      emit(GetRecommendedHotelsSuccess(hotels));
    } catch (e) {
      emit(HomeFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onGetTopRatedHotels(
    GetTopRatedHotels event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _homeRepository.getTopRatedHotels(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final hotels = results[0] as List<HotelModel>;
      emit(GetTopRatedHotelsSuccess(hotels));
    } catch (e) {
      emit(HomeFailure(_translateError(e.toString())));
    }
  }

  void _onToggleFavoriteLocal(
    ToggleFavoriteLocal event,
    Emitter<HomeState> emit,
  ) {
    List<HotelModel> toggle(List<HotelModel> list) {
      return list.map((h) {
        if (h.id == event.hotelId) {
          return h.copyWith(isFavorite: !h.isFavorite);
        }
        return h;
      }).toList();
    }

    if (state is GetPopularHotelsSuccess) {
      final current = state as GetPopularHotelsSuccess;
      emit(GetPopularHotelsSuccess(toggle(current.hotels)));
    }

    if (state is GetRecommendedHotelsSuccess) {
      final current = state as GetRecommendedHotelsSuccess;
      emit(GetRecommendedHotelsSuccess(toggle(current.hotels)));
    }

    if (state is GetTopRatedHotelsSuccess) {
      final current = state as GetTopRatedHotelsSuccess;
      emit(GetTopRatedHotelsSuccess(toggle(current.hotels)));
    }
  }

  Future<void> _onAddFavorite(
    AddFavorite event,
    Emitter<HomeState> emit,
  ) async {
    await _homeRepository.addFavorite(event.hotelId);
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<HomeState> emit,
  ) async {
    await _homeRepository.removeFavorite(event.hotelId);
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
