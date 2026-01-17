import '../models/hotel_model.dart';

abstract class HomeRepository {
  Future<List<HotelModel>> getAllHotels();
  Future<List<HotelModel>> getPopularHotels();
  Future<List<HotelModel>> getRecommendedHotels();
  Future<List<HotelModel>> getTopRatedHotels();
  Future<List<HotelModel>> getHotelByName(String name);
  Future<void> addFavorite(String hotelId);
  Future<void> removeFavorite(String hotelId);
}
