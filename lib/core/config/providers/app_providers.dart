import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/presentation/bloc/auth/login/login_bloc.dart';
import 'package:holla/presentation/bloc/auth/register/register_bloc.dart';
import 'package:holla/presentation/bloc/auth/verify/verify_bloc.dart';
import 'package:holla/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:holla/presentation/bloc/forgot_password/reset_pass/reset_password_bloc.dart';
import 'package:holla/presentation/bloc/forgot_password/send_mail/send_mail_bloc.dart';
import 'package:holla/presentation/bloc/home/home_bloc.dart';
import 'package:holla/presentation/bloc/location/location_bloc.dart';
import 'package:holla/presentation/bloc/search/search_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/repository/auth_repo.dart';
import 'package:holla/repository/favorite_repo.dart';
import 'package:holla/repository/forgot_password_repo.dart';
import 'package:holla/repository/home_repo.dart';
import 'package:holla/repository/location_repo.dart';
import 'package:holla/repository/notification_repo.dart';
import '../../../presentation/bloc/forgot_password/verify_pass/verify_password_bloc.dart';
import '../../../presentation/bloc/notification/notification_bloc.dart';
import '../../../repository/setting_repo.dart';

final blocProviders = <BlocProvider>[
  BlocProvider<LocationBloc>(
    create:
        (context) => LocationBloc(
          locationRepository: context.read<LocationRepository>(),
        ),
  ),

  BlocProvider<LoginBloc>(
    create:
        (context) => LoginBloc(authRepository: context.read<AuthRepository>()),
  ),

  BlocProvider<RegisterBloc>(
    create:
        (context) =>
            RegisterBloc(authRepository: context.read<AuthRepository>()),
  ),

  BlocProvider<VerifyBloc>(
    create:
        (context) => VerifyBloc(authRepository: context.read<AuthRepository>()),
  ),

  BlocProvider<SendMailBloc>(
    create:
        (context) => SendMailBloc(
          forgotPasswordRepository: context.read<ForgotPasswordRepository>(),
        ),
  ),

  BlocProvider<VerifyPasswordBloc>(
    create:
        (context) => VerifyPasswordBloc(
          forgotPasswordRepository: context.read<ForgotPasswordRepository>(),
        ),
  ),
  BlocProvider<ResetPasswordBloc>(
    create:
        (context) => ResetPasswordBloc(
          forgotPasswordRepository: context.read<ForgotPasswordRepository>(),
        ),
  ),

  BlocProvider<SettingBloc>(
    create:
        (context) => SettingBloc(
          authRepository: context.read<AuthRepository>(),
          settingRepository: context.read<SettingRepository>(),
        ),
  ),

  BlocProvider<NotificationBloc>(
    create:
        (context) => NotificationBloc(
          notificationRepository: context.read<NotificationRepository>(),
        ),
  ),

  BlocProvider<HomeBloc>(
    create:
        (context) => HomeBloc(homeRepository: context.read<HomeRepository>()),
  ),

  BlocProvider<SearchBloc>(
    create:
        (context) => SearchBloc(homeRepository: context.read<HomeRepository>()),
  ),
  BlocProvider<FavoriteBloc>(
    create:
        (context) => FavoriteBloc(
          favoriteRepository: context.read<FavoriteRepository>(),
        ),
  ),
];
