import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/models/place_detail_model.dart';
import 'package:holla/models/place_prediction_model.dart';
import 'package:http/http.dart' as http;

class LocationRepository {
  final String apiKey;

  LocationRepository(this.apiKey);

  Future<List<PlacePrediction>> fetchPredictions(String input) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=vi",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['predictions'] as List)
          .map((e) => PlacePrediction.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch predictions");
    }
  }

  Future<PlaceDetail> fetchPlaceDetail(String placeId) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=vi",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return PlaceDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch place detail");
    }
  }

  Future<LatLng?> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }
}
