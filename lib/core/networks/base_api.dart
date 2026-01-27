import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiBase {
  static const String baseUrl = "http://10.0.3.2:8080/api/v1";
}

class ApiKey {
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? "";
  static String get goongApiKey => dotenv.env['GOONG_API_KEY'] ?? "";
  static String get mapboxPublicToken =>
      dotenv.env['MAPBOX_PUBLIC_TOKEN'] ?? "";
}
