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
}
