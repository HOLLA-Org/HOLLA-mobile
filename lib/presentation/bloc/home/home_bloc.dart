import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

  Future<void> _onGetAllHotels(
    GetAllHotels event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final hotels = await _homeRepository.getAllHotels();
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
      final hotels = await _homeRepository.getPopularHotels();
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
      final hotels = await _homeRepository.getRecommendedHotels();
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
      final hotels = await _homeRepository.getTopRatedHotels();
      emit(GetTopRatedHotelsSuccess(hotels));
    } catch (e) {
      emit(HomeFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
