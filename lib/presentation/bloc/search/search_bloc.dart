import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../../repository/home_repo.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepository _homeRepository;

  SearchBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(SearchInitial()) {
    on<SearchHotels>(_onSearchHotels);
    on<ClearSearch>(_onClearSearch);
    on<ToggleSearchFavorite>(_onToggleSearchFavorite);
  }

  Future<void> _onSearchHotels(
    SearchHotels event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final hotels = await _homeRepository.getHotelByName(event.name);
      emit(SearchSuccess(hotels));
    } catch (e) {
      emit(SearchFailure(_translateError(e.toString())));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  void _onToggleSearchFavorite(
    ToggleSearchFavorite event,
    Emitter<SearchState> emit,
  ) {
    if (state is! SearchSuccess) return;

    final current = state as SearchSuccess;

    final updatedHotels =
        current.hotels.map((hotel) {
          if (hotel.id == event.hotelId) {
            return hotel.copyWith(isFavorite: !hotel.isFavorite);
          }
          return hotel;
        }).toList();

    emit(SearchSuccess(updatedHotels));
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
