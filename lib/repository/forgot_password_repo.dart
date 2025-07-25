import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ForgotPasswordRepository {
  final String _baseUrl = 'http://10.0.2.2:8080/api/v1';

  Future<void> sendMail({required String email}) async {
    final Uri sendCodeUrl = Uri.parse('$_baseUrl/auth/forgot-password');

    try {
      final response = await http.post(
        sendCodeUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorMessage = responseBody['message'] as String?;
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<String> verifyPassword({
    required String email,
    required String code,
  }) async {
    final Uri verifyUrl = Uri.parse('$_baseUrl/auth/check-validcode');

    try {
      final response = await http.post(
        verifyUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseBody['data']?['token'] as String?;
        if (token == null) {
          throw Exception('Token was not provided by the server.');
        }
        return token;
      } else {
        final errorMessage = responseBody['message'] as String?;
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('Failed to connect to the server.');
    }
  }

  Future<void> resendCode({required String email}) async {
    final Uri resendUrl = Uri.parse('$_baseUrl/auth/resend-code');

    try {
      final response = await http.post(
        resendUrl,
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

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final Uri resendUrl = Uri.parse('$_baseUrl/auth/reset-password');

    try {
      final response = await http.post(
        resendUrl,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'token': token, 'newPassword': newPassword}),
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
}
