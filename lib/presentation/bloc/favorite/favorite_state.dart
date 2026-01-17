import 'package:equatable/equatable.dart';
import 'package:holla/models/hotel_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class GetAllFavoriteSuccess extends FavoriteState {
  final List<HotelModel> hotels;
  const GetAllFavoriteSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class FavoriteFailure extends FavoriteState {
  final String error;
  const FavoriteFailure(this.error);

  @override
  List<Object?> get props => [error];
}
