import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:holla/models/user_model.dart';

import '../core/networks/api_constants.dart';
import '../repository/setting_repo.dart';

class SettingService implements SettingRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<UserModel> getUserProfile() async {
    final uri = Uri.parse(ApiConstant.getUserProfile);

    final token = await _storage.read(key: 'accessToken');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Token $token');

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = responseBody['data'] as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else {
        final errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? username,
    String? email,
    String? phone,
    String? address,
    String? gender,
    DateTime? dateOfBirth,
  }) async {
    final uri = Uri.parse(ApiConstant.updateProfile);
    final token = await _storage.read(key: 'accessToken');

    final payload = {
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth.toIso8601String(),
    };

    try {
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(body['data']);
      } else {
        final errorMessage = body['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<UserModel> updateAvatar(String avatarUrl) async {
    final uri = Uri.parse(ApiConstant.updateAvatar);
    final token = await _storage.read(key: 'accessToken');

    try {
      final response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'avatarUrl': avatarUrl}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(body['data']);
      } else {
        final errorMessage = body['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
