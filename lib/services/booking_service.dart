import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../core/networks/api_constants.dart';
import '../models/hotel_detail_model.dart';
import '../models/review_model.dart';
import '../repository/booking_repo.dart';

class BookingService implements BookingRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<HotelDetailModel> getHotelDetail(String hotelId) async {
    final uri = Uri.parse('${ApiConstant.getHotelDetail}/$hotelId');
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
        return HotelDetailModel.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<List<ReviewModel>> getHotelReviews(String hotelId) async {
    final uri = Uri.parse('${ApiConstant.getHotelReviews}/$hotelId');
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
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
