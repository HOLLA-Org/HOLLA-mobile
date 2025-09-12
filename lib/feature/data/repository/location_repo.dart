import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/feature/data/models/place_prediction_model.dart';
import 'package:http/http.dart' as http;

class LocationRepository {
  final String apiKey;

  LocationRepository(this.apiKey);

  Future<List<PlacePrediction>> fetchPredictions(String input) async {
    if (input.isEmpty) return [];
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search"
      "?q=$input&format=json&addressdetails=1&limit=5",
    );

    final response = await http.get(url, headers: {"User-Agent": "holla-app"});
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) {
        return PlacePrediction(
          placeId: e["osm_id"].toString(),
          description: e["display_name"],
          lat: double.parse(e["lat"]),
          lng: double.parse(e["lon"]),
        );
      }).toList();
    } else {
      throw Exception("Failed to fetch predictions");
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
