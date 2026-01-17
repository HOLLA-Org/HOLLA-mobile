import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchHotels extends SearchEvent {
  final String name;

  const SearchHotels(this.name);

  @override
  List<Object?> get props => [name];
}

class ToggleSearchFavorite extends SearchEvent {
  final String hotelId;
  const ToggleSearchFavorite(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}

class ClearSearch extends SearchEvent {}
