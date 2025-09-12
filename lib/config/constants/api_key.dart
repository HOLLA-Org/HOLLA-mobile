import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKey {
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY']!;
}
