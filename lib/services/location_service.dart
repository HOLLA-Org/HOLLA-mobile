import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:holla/models/place_detail_model.dart';
import 'package:holla/models/place_prediction_model.dart';
import 'package:holla/repository/location_repo.dart';
import 'package:http/http.dart' as http;

import '../core/networks/base_api.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:holla/core/networks/api_constants.dart';
import 'package:holla/models/location_model.dart';
import 'dart:io';

class LocationService implements LocationRepository {
  final _storage = const FlutterSecureStorage();
  LocationService();

  @override
  Future<List<LocationModel>> getLocations() async {
    final uri = Uri.parse(ApiConstant.getLocations);
    final token = await _storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List list = body['data'] as List;
        return list
            .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<List<PlacePrediction>> fetchPredictions(String input) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${ApiKey.googleApiKey}&language=vi",
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

  @override
  Future<PlaceDetail> fetchPlaceDetail(String placeId) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${ApiKey.googleApiKey}&language=vi",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return PlaceDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch place detail");
    }
  }

  @override
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
