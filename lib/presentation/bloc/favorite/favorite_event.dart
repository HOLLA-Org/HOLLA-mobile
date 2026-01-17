import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}

class GetAllFavorite extends FavoriteEvent {}

class RemoveFavorite extends FavoriteEvent {
  final String hotelId;
  const RemoveFavorite(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}
