import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/repository/favorite_repo.dart';

import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteBloc({required FavoriteRepository favoriteRepository})
    : _favoriteRepository = favoriteRepository,
      super(FavoriteInitial()) {
    on<GetAllFavorite>(_onGetAllFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
  }

  Future<void> _onGetAllFavorite(
    GetAllFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final favorites = await _favoriteRepository.getAllFavorite();
      emit(GetAllFavoriteSuccess(favorites));
    } catch (e) {
      emit(FavoriteFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await _favoriteRepository.removeFavorite(event.hotelId);
      add(GetAllFavorite());
    } catch (e) {
      emit(FavoriteFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
