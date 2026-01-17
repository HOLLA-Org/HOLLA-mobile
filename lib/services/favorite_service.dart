import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:holla/models/hotel_model.dart';
import 'package:holla/repository/favorite_repo.dart';
import 'package:http/http.dart' as http;

import '../core/networks/api_constants.dart';

class FavoriteService implements FavoriteRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<List<HotelModel>> getAllFavorite() async {
    final uri = Uri.parse(ApiConstant.getAllFavorite);
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
            .map((e) => HotelModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<void> removeFavorite(String hotelId) async {
    final uri = Uri.parse('${ApiConstant.removeFavorite}/$hotelId');
    final token = await _storage.read(key: 'accessToken');

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
