import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetAllHotels extends HomeEvent {}

class GetPopularHotels extends HomeEvent {}

class GetRecommendedHotels extends HomeEvent {}

class GetTopRatedHotels extends HomeEvent {}

class GetHotelByName extends HomeEvent {
  final String name;

  const GetHotelByName(this.name);

  @override
  List<Object?> get props => [name];
}

class AddFavorite extends HomeEvent {
  final String hotelId;
  const AddFavorite(this.hotelId);
}

class RemoveFavorite extends HomeEvent {
  final String hotelId;
  const RemoveFavorite(this.hotelId);
}

class ToggleFavoriteLocal extends HomeEvent {
  final String hotelId;
  const ToggleFavoriteLocal(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}
