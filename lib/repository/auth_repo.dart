// In your auth_repo.dart file

import 'dart:convert';
import 'dart:io'; // Import để xử lý SocketException
import 'package:http/http.dart' as http;
import 'package:holla/models/auth_model.dart';

class AuthRepository {
  final String _baseUrl = 'http://10.0.2.2:8080/api/v1';

  Future<AuthModel> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final Uri registerUrl = Uri.parse('$_baseUrl/auth/register');

    try {
      final response = await http.post(
        registerUrl,
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
}
