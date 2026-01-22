import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class GetHotelDetail extends BookingEvent {
  final String hotelId;

  const GetHotelDetail(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}

class GetHotelReviews extends BookingEvent {
  final String hotelId;

  const GetHotelReviews(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}
