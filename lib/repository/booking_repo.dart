import '../models/hotel_detail_model.dart';
import '../models/review_model.dart';

abstract class BookingRepository {
  Future<HotelDetailModel> getHotelDetail(String hotelId);
  Future<List<ReviewModel>> getHotelReviews(String hotelId);
}
