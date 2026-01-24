import '../models/booking_model.dart';
import '../models/hotel_detail_model.dart';
import '../models/review_model.dart';

abstract class BookingRepository {
  Future<HotelDetailModel> getHotelDetail(String hotelId);
  Future<List<ReviewModel>> getHotelReviews(String hotelId);
  Future<String> createBooking({
    required String hotelId,
    required String bookingType,
    DateTime? checkIn,
    DateTime? checkOut,
  });
  Future<List<BookingModel>> getBookingHistory(BookingStatus status);
}
