import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/bloc/auth/register/register_bloc.dart';
import 'package:holla/bloc/auth/verify/verify_bloc.dart';
import 'package:holla/config/theme.dart';
import 'package:holla/repository/auth_repo.dart';
import 'package:holla/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(authRepository: authRepository),
          ),
          BlocProvider<VerifyBloc>(
            create: (context) => VerifyBloc(authRepository: authRepository),
          ),
        ],
        child: MaterialApp.router(
          title: 'HoLLa',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
