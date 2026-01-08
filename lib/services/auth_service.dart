import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:holla/models/auth_model.dart';

import '../core/networks/api_constants.dart';
import '../repository/auth_repo.dart';

class AuthService implements AuthRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<AuthModel> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final uri = Uri.parse(ApiConstant.register);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final userData = responseBody['data'] as Map<String, dynamic>;
        return AuthModel.fromJson(userData);
      } else {
        final errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<AuthModel> login(String emailOrUsername, String password) async {
    final uri = Uri.parse(ApiConstant.login);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'account': emailOrUsername, 'password': password}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = responseBody['data'] as Map<String, dynamic>;
        return AuthModel.fromJson(userData);
      } else {
        final errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<void> verifyCode(String email, String code) async {
    final uri = Uri.parse(ApiConstant.verify);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'codeId': code}),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<void> resendCode(String email) async {
    final uri = Uri.parse(ApiConstant.resend);

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode != 200) {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  @override
  Future<void> logout() async {
    final uri = Uri.parse(ApiConstant.logout);
    final accessToken = await _storage.read(key: 'accessToken');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'];
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }
}
