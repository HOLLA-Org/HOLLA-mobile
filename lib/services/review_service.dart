import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../core/networks/api_constants.dart';
import '../repository/review_repo.dart';

class ReviewService implements ReviewRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> createReview({
    required String bookingId,
    required double rating,
    required String comment,
  }) async {
    final uri = Uri.parse(ApiConstant.createReview);
    final token = await _storage.read(key: 'accessToken');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'booking_id': bookingId,
          'rating': rating,
          'comment': comment,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
