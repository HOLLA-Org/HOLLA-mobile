import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/bloc/auth/login/login_bloc.dart';
import 'package:holla/presentation/bloc/auth/login/login_event.dart';
import 'package:holla/presentation/bloc/auth/login/login_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/textfield_custom.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_event.dart';
import 'package:holla/presentation/bloc/setting/setting_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailOrUsernameController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _emailOrUsernameController.removeListener(_onFormChanged);
    _passwordController.removeListener(_onFormChanged);
    _emailOrUsernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    context.read<LoginBloc>().add(
      LoginFormChanged(
        emailOrUsername: _emailOrUsernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _handleForgotPassWord() {
    context.go(AppRoutes.sendmail);
  }

  void _handleNavigateToRegister() {
    context.go(AppRoutes.register);
  }

  void _handleLogin() {
    context.read<LoginBloc>().add(
      LoginSubmitted(
        emailOrUsername: _emailOrUsernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void showLoginFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'login.failure'.tr(),
      message: error,
      isError: true,
    );
  }

  void _onLoginStateChanged(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      context.read<SettingBloc>().add(GetUserProfile());
    } else if (state is LoginFailure) {
      showLoginFailure(context, state.error);
    }
  }

  void _onSettingStateChanged(BuildContext context, SettingState state) {
    if (state is GetUserProfileSuccess) {
      final user = state.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('login.success'.tr()),
          backgroundColor: const Color(0xFF008080),
        ),
      );

      if (user.address != null &&
          user.address!.isNotEmpty &&
          user.locationName != null &&
          user.locationName!.isNotEmpty) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.locationpermission);
      }
    } else if (state is GetUserProfileFailure) {
      showLoginFailure(context, state.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          BlocListener<LoginBloc, LoginState>(listener: _onLoginStateChanged),
          BlocListener<SettingBloc, SettingState>(
            listener: _onSettingStateChanged,
          ),
        ],
        child: Column(
          children: [
            // --- Header ---
            Stack(
              children: [
                const Image(
                  image: AssetImage('assets/images/main_elip_big.png'),
                  width: double.infinity,
                  height: 380,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 110,
                      left: 24.0,
                      right: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'login.title'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'login.subtitle'.tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'CrimsonText',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // --- Form ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  bool isFormValid = false;
                  Set<String> invalidFields = {};

                  if (state is LoginInitial) {
                    isFormValid = state.isFormValid;
                    invalidFields = state.invalidFields;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFieldCustom(
                        controller: _emailOrUsernameController,
                        hintText: 'login.username_label'.tr(),
                        prefixIcon: Icons.person,
                        hasError: invalidFields.contains('emailOrUsername'),
                      ),
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        controller: _passwordController,
                        hintText: 'login.password_label'.tr(),
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError: invalidFields.contains('password'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextButton(
                          onPressed: _handleForgotPassWord,
                          child: Text(
                            "login.forgot_password".tr(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CrimsonText',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child:
                            (state is LoginLoading)
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ConfirmButton(
                                  text: "login.submit".tr(),
                                  color:
                                      isFormValid
                                          ? const Color(0xFF008080)
                                          : Colors.grey,
                                  onPressed: isFormValid ? _handleLogin : null,
                                ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const Spacer(),

            // --- Footer ---
            Stack(
              children: [
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Image(
                    image: AssetImage('assets/images/main_elip_small.png'),
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 16.0),
                      child: TextButton(
                        onPressed: _handleNavigateToRegister,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'login.footer_action'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CrimsonText',
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Image(
                              image: AssetImage('assets/icons/arrow_left.png'),
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
