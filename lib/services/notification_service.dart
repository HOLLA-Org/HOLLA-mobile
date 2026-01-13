import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../core/networks/api_constants.dart';
import '../models/notification_model.dart';
import '../repository/notification_repo.dart';

class NotificationService implements NotificationRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final uri = Uri.parse(ApiConstant.getNotification);
    final token = await _storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List list = responseBody['data'] as List;

        return list
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(responseBody['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    final uri = Uri.parse('${ApiConstant.deleteNotification}/$id');

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorMessage = body['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    final uri = Uri.parse(ApiConstant.deleteAllNotification);

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

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final errorMessage = body['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
