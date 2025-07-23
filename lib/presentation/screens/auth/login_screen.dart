// lib/presentation/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/bloc/auth/login/login_bloc.dart';
import 'package:holla/bloc/auth/login/login_event.dart';
import 'package:holla/bloc/auth/login/login_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/textfield_custom.dart';
import 'package:holla/routes/app_routes.dart';

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

  // --- Handler Functions ---

  // Dispatches a form changed event to the BLoC on input change
  void _onFormChanged() {
    context.read<LoginBloc>().add(
      LoginFormChanged(
        emailOrUsername: _emailOrUsernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  // Navigates to the forgot password screen
  void _handleForgotPassWord() {
    context.go(AppRoutes.forgotpassword);
  }

  // Navigates to the register screen
  void _handleNavigateToRegister() {
    context.go(AppRoutes.register);
  }

  // Dispatches a login submission event to the BLoC
  void _handleLogin() {
    context.read<LoginBloc>().add(
      LoginSubmitted(
        emailOrUsername: _emailOrUsernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void showLoginSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đang nhập thành công!'),
        backgroundColor: const Color(0xFF008080),
      ),
    );
    context.go(AppRoutes.home);
  }

  // Shows an error dialog upon login failure
  void showLoginFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'Đăng nhập thất bại',
      message: error,
      isError: true,
    );
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            showLoginSuccess(context);
          } else if (state is LoginFailure) {
            showLoginFailure(context, state.error);
          }
        },
        child: Column(
          children: [
            // --- Header ---
            Stack(
              children: [
                Image(
                  image: const AssetImage('assets/images/main_elip_big.png'),
                  width: double.infinity,
                  height: 380,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.only(top: 110, left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đăng nhập tài khoản',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chào mừng bạn trở lại! Vui lòng đăng nhập\nđể tiếp tục hành trình cùng HoLLa',
                          style: TextStyle(
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
                        hintText: 'Tên đăng nhập hoặc email',
                        prefixIcon: Icons.person,
                        hasError: invalidFields.contains('emailOrUsername'),
                      ),
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        controller: _passwordController,
                        hintText: 'Mật khẩu',
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError: invalidFields.contains('password'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextButton(
                          onPressed: _handleForgotPassWord,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
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
                                  text: "Đăng nhập",
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Đăng kí',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CrimsonText',
                              ),
                            ),
                            SizedBox(width: 8),
                            Image(
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
