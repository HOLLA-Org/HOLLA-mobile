import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../core/networks/api_constants.dart';
import '../models/home_model.dart';
import '../repository/home_repo.dart';

class HomeService implements HomeRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<List<HomeModel>> getAllHotels() async {
    final uri = Uri.parse(ApiConstant.getAllHotels);
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
            .map((e) => HomeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<List<HomeModel>> getPopularHotels() async {
    final uri = Uri.parse(ApiConstant.getPopularHotels);
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
            .map((e) => HomeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<List<HomeModel>> getRecommendedHotels() async {
    final uri = Uri.parse(ApiConstant.getRecommendedHotels);
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
            .map((e) => HomeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<List<HomeModel>> getTopRatedHotels() async {
    final uri = Uri.parse(ApiConstant.getTopRatedHotels);
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
            .map((e) => HomeModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message']);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
