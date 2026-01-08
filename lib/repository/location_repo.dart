import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/models/place_detail_model.dart';
import 'package:holla/models/place_prediction_model.dart';

abstract class LocationRepository {
  Future<List<PlacePrediction>> fetchPredictions(String input);

  Future<PlaceDetail> fetchPlaceDetail(String placeId);

  Future<LatLng?> getCurrentLocation();
}
