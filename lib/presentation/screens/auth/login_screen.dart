import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                Image(
                  image: const AssetImage('assets/images/main_elip_big.png'),
                  width: double.infinity,
                  height: 340.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 250.h,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 110.h,
                      left: 24.w,
                      right: 24.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'login.title'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'login.subtitle'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
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
                      SizedBox(height: 10.h),
                      TextFieldCustom(
                        controller: _passwordController,
                        hintText: 'login.password_label'.tr(),
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError: invalidFields.contains('password'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: TextButton(
                          onPressed: _handleForgotPassWord,
                          child: Text(
                            "login.forgot_password".tr(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CrimsonText',
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image(
                    image: const AssetImage(
                      'assets/images/main_elip_small.png',
                    ),
                    fit: BoxFit.cover,
                    height: 100.h,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100.h,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h, right: 16.w),
                      child: TextButton(
                        onPressed: _handleNavigateToRegister,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'login.footer_action'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CrimsonText',
                              ),
                            ),
                            SizedBox(width: 8.w),
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
