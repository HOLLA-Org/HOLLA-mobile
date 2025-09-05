import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/core/networks/base_api.dart';
import 'package:holla/repository/auth_repo.dart';
import 'package:holla/repository/forgot_password_repo.dart';
import 'package:holla/repository/location_repo.dart';

final AuthRepository authRepository = AuthRepository();
final ForgotPasswordRepository forgotPasswordRepository =
    ForgotPasswordRepository();
final LocationRepository locationRepository = LocationRepository(
  ApiKey.googleApiKey,
);

final repositoryProviders = <RepositoryProvider>[
  RepositoryProvider.value(value: authRepository),
  RepositoryProvider.value(value: forgotPasswordRepository),
  RepositoryProvider.value(value: locationRepository),
];
