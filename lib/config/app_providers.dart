import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/bloc/auth/login/login_bloc.dart';
import 'package:holla/bloc/auth/register/register_bloc.dart';
import 'package:holla/bloc/auth/verify/verify_bloc.dart';
import 'package:holla/bloc/forgot_password/send_mail/send_mail_bloc.dart';
import 'package:holla/config/repository_provider.dart';

import '../bloc/forgot_password/verify_pass/verify_password_bloc.dart';

final blocProviders = <BlocProvider>[
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
];
