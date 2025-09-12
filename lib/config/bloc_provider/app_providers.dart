import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/feature/presentation/bloc/auth/login/login_bloc.dart';
import 'package:holla/feature/presentation/bloc/auth/register/register_bloc.dart';
import 'package:holla/feature/presentation/bloc/auth/verify/verify_bloc.dart';
import 'package:holla/feature/presentation/bloc/forgot_password/reset_pass/reset_password_bloc.dart';
import 'package:holla/feature/presentation/bloc/forgot_password/send_mail/send_mail_bloc.dart';
import 'package:holla/feature/presentation/bloc/location/location_bloc.dart';
import 'package:holla/feature/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/config/bloc_provider/repository_provider.dart';
import '../../feature/presentation/bloc/forgot_password/verify_pass/verify_password_bloc.dart';

final blocProviders = <BlocProvider>[
  BlocProvider<LocationBloc>(create: (_) => LocationBloc(locationRepository)),

  BlocProvider<LoginBloc>(
    create: (_) => LoginBloc(authRepository: authRepository),
  ),

  BlocProvider<RegisterBloc>(
    create: (_) => RegisterBloc(authRepository: authRepository),
  ),

  BlocProvider<VerifyBloc>(
    create: (_) => VerifyBloc(authRepository: authRepository),
  ),

  BlocProvider<SendMailBloc>(
    create:
        (_) => SendMailBloc(forgotPasswordRepository: forgotPasswordRepository),
  ),
  BlocProvider<VerifyPasswordBloc>(
    create:
        (_) => VerifyPasswordBloc(
          forgotPasswordRepository: forgotPasswordRepository,
        ),
  ),
  BlocProvider<ResetPasswordBloc>(
    create:
        (_) => ResetPasswordBloc(
          forgotPasswordRepository: forgotPasswordRepository,
        ),
  ),

  BlocProvider<SettingBloc>(
    create: (_) => SettingBloc(authRepository: authRepository),
  ),
];
