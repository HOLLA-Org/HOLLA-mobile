import 'package:equatable/equatable.dart';
import '../../../models/home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class GetAllHotelsSuccess extends HomeState {
  final List<HomeModel> hotels;
  const GetAllHotelsSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class GetPopularHotelsSuccess extends HomeState {
  final List<HomeModel> hotels;
  const GetPopularHotelsSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class GetRecommendedHotelsSuccess extends HomeState {
  final List<HomeModel> hotels;
  const GetRecommendedHotelsSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class GetTopRatedHotelsSuccess extends HomeState {
  final List<HomeModel> hotels;
  const GetTopRatedHotelsSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class GetHotelByNameSuccess extends HomeState {
  final List<HomeModel> hotels;
  const GetHotelByNameSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class HomeFailure extends HomeState {
  final String error;

  const HomeFailure(this.error);

  @override
  List<Object?> get props => [error];
}
