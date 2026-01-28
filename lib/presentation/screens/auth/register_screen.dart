import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:holla/presentation/bloc/auth/register/register_bloc.dart';
import 'package:holla/presentation/bloc/auth/register/register_event.dart';
import 'package:holla/presentation/bloc/auth/register/register_state.dart';
import 'package:holla/models/auth_model.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/textfield_custom.dart';
import 'package:holla/core/config/routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers to manage text field input
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to changes in password fields to validate them

    _usernameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
    _confirmPasswordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onFormChanged);
    _emailController.removeListener(_onFormChanged);
    _passwordController.removeListener(_onFormChanged);
    _confirmPasswordController.removeListener(_onFormChanged);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Handler Functions ---

  void _onFormChanged() {
    context.read<RegisterBloc>().add(
      RegisterFormChanged(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void _handleNavigateToLogin() {
    context.go(AppRoutes.login);
  }

  void _handleRegister() {
    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void showRegisterSuccess(BuildContext context, AuthModel auth) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'register.welcome_activate'.tr(
            namedArgs: {'username': auth.username},
          ),
        ),
        backgroundColor: const Color(0xFF008080),
      ),
    );
    context.go(AppRoutes.verify, extra: auth.email);
  }

  void showRegisterFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'register.failure'.tr(),
      message: error,
      isError: true,
    );
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            showRegisterSuccess(context, state.auth);
          } else if (state is RegisterFailure) {
            showRegisterFailure(context, state.error);
          }
        },
        child: Column(
          children: [
            // --- Header ---
            Stack(
              children: [
                // Background Image
                Image(
                  image: const AssetImage(
                    'assets/images/main/main_elip_big.png',
                  ),
                  width: double.infinity,
                  height: 340.h,
                  fit: BoxFit.cover,
                ),
                // Text Content
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
                          'register.title'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'register.subtitle'.tr(),
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

              child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  bool isFormValid = false;
                  Set<String> invalidFields = {};
                  bool passwordsDontMatch = false;
                  if (state is RegisterInitial) {
                    isFormValid = state.isFormValid;
                    invalidFields = state.invalidFields;
                    passwordsDontMatch = !state.passwordsMatch;
                  }
                  return Column(
                    children: [
                      TextFieldCustom(
                        controller: _usernameController,
                        hintText: 'register.username_label'.tr(),
                        prefixIcon: Icons.person,
                        hasError: invalidFields.contains('username'),
                      ),
                      SizedBox(height: 10.h),
                      TextFieldCustom(
                        controller: _emailController,
                        hintText: 'register.email_label'.tr(),
                        prefixIcon: Icons.email,
                        hasError: invalidFields.contains('email'),
                      ),
                      SizedBox(height: 10.h),
                      TextFieldCustom(
                        controller: _passwordController,
                        hintText: 'register.password_label'.tr(),
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError:
                            passwordsDontMatch ||
                            invalidFields.contains('password'),
                      ),
                      SizedBox(height: 10.h),
                      TextFieldCustom(
                        controller: _confirmPasswordController,
                        hintText: 'register.confirm_password_label'.tr(),
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError:
                            passwordsDontMatch ||
                            invalidFields.contains('confirmPassword'),
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,

                        child:
                            (state is RegisterLoading)
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ConfirmButton(
                                  text: "register.submit".tr(),
                                  color:
                                      isFormValid
                                          ? const Color(0xFF008080)
                                          : Colors.grey,
                                  onPressed:
                                      isFormValid ? _handleRegister : null,
                                ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Spacer added to push the footer to the bottom
            const Spacer(),

            // --- Footer ---
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image(
                    image: const AssetImage(
                      'assets/images/main/main_elip_small.png',
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
                      padding: EdgeInsets.only(bottom: 20.h, right: 4.w),
                      child: TextButton(
                        onPressed: _handleNavigateToLogin,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'register.footer_action'.tr(),
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
