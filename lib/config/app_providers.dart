import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/bloc/auth/login/login_bloc.dart';
import 'package:holla/bloc/auth/register/register_bloc.dart';
import 'package:holla/bloc/auth/verify/verify_bloc.dart';
import 'package:holla/repository/auth_repo.dart';

final allBlocProviders = <BlocProvider>[
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
];
