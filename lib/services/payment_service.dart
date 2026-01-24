import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:holla/core/networks/api_constants.dart';
import 'package:holla/models/payment_model.dart';
import 'package:holla/models/discount_model.dart';
import 'package:holla/repository/payment_repo.dart';

class PaymentService implements PaymentRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<PaymentModel> createPayment({
    required String bookingId,
    required String paymentMethod,
    String? discountCode,
  }) async {
    final uri = Uri.parse(ApiConstant.createPayment);
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
          'payment_method': paymentMethod,
          if (discountCode != null) 'discount_code': discountCode,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentModel.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        throw Exception(body['message'] ?? 'Payment failed');
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<List<DiscountModel>> getDiscounts() async {
    final uri = Uri.parse(ApiConstant.getAllDiscounts);
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

      if (response.statusCode == 200) {
        final List<dynamic> data = body['data'] ?? body;
        return data.map((item) => DiscountModel.fromJson(item)).toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
