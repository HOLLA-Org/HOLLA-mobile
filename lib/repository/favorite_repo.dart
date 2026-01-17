import 'package:holla/models/hotel_model.dart';

abstract class FavoriteRepository {
  Future<List<HotelModel>> getAllFavorite();
  Future<void> removeFavorite(String hotelId);
}
