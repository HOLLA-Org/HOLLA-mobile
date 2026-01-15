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

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
