import 'package:equatable/equatable.dart';
import '../../../models/hotel_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<HotelModel> hotels;

  const SearchSuccess(this.hotels);

  @override
  List<Object?> get props => [hotels];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object?> get props => [error];
}
