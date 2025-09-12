import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/feature/presentation/bloc/auth/register/register_bloc.dart';
import 'package:holla/feature/presentation/bloc/auth/register/register_event.dart';
import 'package:holla/feature/presentation/bloc/auth/register/register_state.dart';
import 'package:holla/feature/data/models/auth_model.dart';
import 'package:holla/feature/presentation/widget/confirm_button.dart';
import 'package:holla/feature/presentation/widget/notification_dialog.dart';
import 'package:holla/feature/presentation/widget/textfield_custom.dart';
import 'package:holla/config/routes/app_routes.dart';

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
          'Chào mừng, ${auth.username}. Vui lòng kích hoạt tài khoản của bạn!'
              .tr(),
        ),
        backgroundColor: const Color(0xFF008080),
      ),
    );
    context.go(AppRoutes.verify, extra: auth.email);
  }

  void showRegisterFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'Đăng kí thất bại'.tr(),
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
                  image: AssetImage('assets/images/main_elip_big.png'),
                  width: double.infinity,
                  height: 380,
                  fit: BoxFit.cover,
                ),
                // Text Content
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.only(top: 110, left: 24.0, right: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tạo tài khoản'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlayfairDisplay',
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tạo tài khoản để bắt đầu hành trình tìm phòng\nlý tưởng cùng HoLLa'
                              .tr(),
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
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),

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
                        hintText: 'Tên đăng nhập'.tr(),
                        prefixIcon: Icons.person,
                        hasError: invalidFields.contains('username'),
                      ),
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        controller: _emailController,
                        hintText: 'Email'.tr(),
                        prefixIcon: Icons.email,
                        hasError: invalidFields.contains('email'),
                      ),
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        controller: _passwordController,
                        hintText: 'Mật khẩu'.tr(),
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError:
                            passwordsDontMatch ||
                            invalidFields.contains('password'),
                      ),
                      const SizedBox(height: 10),
                      TextFieldCustom(
                        controller: _confirmPasswordController,
                        hintText: 'Xác nhận mật khẩu'.tr(),
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        hasError:
                            passwordsDontMatch ||
                            invalidFields.contains('confirmPassword'),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child:
                            (state is RegisterLoading)
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ConfirmButton(
                                  text: "Đăng kí".tr(),
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
                        onPressed: _handleNavigateToLogin,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Đăng nhập'.tr(),
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
