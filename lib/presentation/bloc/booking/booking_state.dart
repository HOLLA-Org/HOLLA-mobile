import 'package:equatable/equatable.dart';
import '../../../models/hotel_detail_model.dart';
import '../../../models/review_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class GetHotelDetailSuccess extends BookingState {
  final HotelDetailModel hotel;

  const GetHotelDetailSuccess(this.hotel);

  @override
  List<Object?> get props => [hotel];
}

class GetHotelReviewsSuccess extends BookingState {
  final List<ReviewModel> reviews;

  const GetHotelReviewsSuccess(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class BookingFailure extends BookingState {
  final String error;

  const BookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
