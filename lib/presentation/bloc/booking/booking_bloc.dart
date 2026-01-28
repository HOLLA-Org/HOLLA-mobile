import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/booking_model.dart';
import '../../../models/hotel_detail_model.dart';
import '../../../models/review_model.dart';
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
    on<GetBookingHistory>(_onGetBookingHistory);
  }

  Future<void> _onGetBookingHistory(
    GetBookingHistory event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final results = await Future.wait([
        _bookingRepository.getBookingHistory(event.status),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final bookings = results[0] as List<BookingModel>;
      emit(GetBookingHistorySuccess(bookings));
    } catch (e) {
      emit(BookingFailure(_translateError(e.toString())));
    }
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
      final results = await Future.wait([
        _bookingRepository.getHotelDetail(event.hotelId),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final hotel = results[0] as HotelDetailModel;
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
      final results = await Future.wait([
        _bookingRepository.getHotelReviews(event.hotelId),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final reviews = results[0] as List<ReviewModel>;
      emit(GetHotelReviewsSuccess(reviews));
    } catch (e) {
      emit(BookingFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
