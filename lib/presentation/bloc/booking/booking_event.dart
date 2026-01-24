import 'package:equatable/equatable.dart';
import '../../../models/booking_model.dart';

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

class CreateBooking extends BookingEvent {
  final String hotelId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String bookingType;

  const CreateBooking({
    required this.hotelId,
    this.checkIn,
    this.checkOut,
    required this.bookingType,
  });

  @override
  List<Object?> get props => [hotelId, checkIn, checkOut, bookingType];
}

class GetBookingHistory extends BookingEvent {
  final BookingStatus status;

  const GetBookingHistory(this.status);

  @override
  List<Object?> get props => [status];
}
