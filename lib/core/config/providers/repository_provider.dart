import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/repository/auth_repo.dart';
import 'package:holla/repository/forgot_password_repo.dart';
import 'package:holla/repository/home_repo.dart';
import 'package:holla/repository/location_repo.dart';
import 'package:holla/repository/notification_repo.dart';
import 'package:holla/repository/setting_repo.dart';
import 'package:holla/services/auth_service.dart';
import 'package:holla/services/forgot_password_service.dart';
import 'package:holla/services/home_service.dart';
import 'package:holla/services/location_service.dart';
import 'package:holla/services/notification_service.dart';
import 'package:holla/services/setting_service.dart';

final repositoryProviders = <RepositoryProvider>[
  RepositoryProvider<AuthRepository>(create: (_) => AuthService()),
  RepositoryProvider<ForgotPasswordRepository>(
    create: (_) => ForgotPasswordService(),
  ),
  RepositoryProvider<LocationRepository>(create: (_) => LocationService()),
  RepositoryProvider<SettingRepository>(create: (_) => SettingService()),
  RepositoryProvider<NotificationRepository>(
    create: (_) => NotificationService(),
  ),
  RepositoryProvider<HomeRepository>(create: (_) => HomeService()),
];
