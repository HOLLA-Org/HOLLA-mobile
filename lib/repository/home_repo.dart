import '../models/home_model.dart';

abstract class HomeRepository {
  Future<List<HomeModel>> getAllHotels();
  Future<List<HomeModel>> getPopularHotels();
  Future<List<HomeModel>> getRecommendedHotels();
  Future<List<HomeModel>> getTopRatedHotels();
  Future<List<HomeModel>> getHotelByName(String name);
  Future<Set<String>> getFavoriteIds();
  Future<void> addFavorite(String hotelId);
  Future<void> removeFavorite(String hotelId);
}
