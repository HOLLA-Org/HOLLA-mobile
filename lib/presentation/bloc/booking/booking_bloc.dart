import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_event.dart';
import 'booking_state.dart';
import '../../../repository/booking_repo.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc({required BookingRepository bookingRepository})
    : _bookingRepository = bookingRepository,
      super(BookingInitial()) {
    on<GetHotelDetail>(_onGetHotelDetail);
    on<GetHotelReviews>(_onGetHotelReviews);
    on<CreateBooking>(_onCreateBooking);
  }

  Future<void> _onCreateBooking(
    CreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookingId = await _bookingRepository.createBooking(
        hotelId: event.hotelId,
        checkIn: event.checkIn,
        checkOut: event.checkOut,
        bookingType: event.bookingType,
      );
      emit(CreateBookingSuccess(bookingId));
    } catch (e) {
      emit(BookingFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onGetHotelDetail(
    GetHotelDetail event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final hotel = await _bookingRepository.getHotelDetail(event.hotelId);
      emit(GetHotelDetailSuccess(hotel));
    } catch (e) {
      emit(BookingFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onGetHotelReviews(
    GetHotelReviews event,
    Emitter<BookingState> emit,
  ) async {
    try {
      final reviews = await _bookingRepository.getHotelReviews(event.hotelId);
      emit(GetHotelReviewsSuccess(reviews));
    } catch (e) {
      emit(BookingFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
