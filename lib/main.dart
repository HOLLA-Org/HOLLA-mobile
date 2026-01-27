import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:holla/core/networks/base_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  MapboxOptions.setAccessToken(ApiKey.mapboxPublicToken);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/lang',
      fallbackLocale: const Locale('vi'),
      child: const MyApp(),
    ),
  );
}
