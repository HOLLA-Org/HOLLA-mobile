import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/bloc/forgot_password/reset_pass/reset_password_bloc.dart';
import 'package:holla/presentation/bloc/forgot_password/reset_pass/reset_password_event.dart';
import 'package:holla/presentation/bloc/forgot_password/reset_pass/reset_password_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/textfield_custom.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/core/utils/helpers.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(_onFormChanged);
    _confirmPasswordController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onFormChanged);
    _confirmPasswordController.removeListener(_onFormChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    context.read<ResetPasswordBloc>().add(
      ResetPasswordFormChanged(
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  void _handleSubmit() {
    context.read<ResetPasswordBloc>().add(
      ResetPasswordSubmitted(token: widget.token),
    );
  }

  void _handleResetPasswordStateChanges(
    BuildContext context,
    ResetPasswordState state,
  ) {
    if (state is ResetPasswordSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mật khẩu của bạn đã được thay đổi!'.tr()),
          backgroundColor: Color(0xFF008080),
        ),
      );
      context.go(AppRoutes.login);
    } else if (state is ResetPasswordFailure) {
      notificationDialog(
        context: context,
        title: 'Cập nhật thất bại'.tr(),
        message: state.error,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: _handleResetPasswordStateChanges,
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  // --- Header ---
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image(
                        image: const AssetImage('assets/images/main_elip.png'),
                        width: double.infinity,
                        height: 320,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        top: -70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 36,
                                  color: Colors.white,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(right: 16.0),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cập nhật mật khẩu'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlayfairDisplay',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Mật khẩu mới phải chứa ít nhất 6 ký tự \nbao gồm chữ hoa, chữ thường, số và kí tự đặc biệt'
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

                  const SizedBox(height: 30),

                  BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                    builder: (context, state) {
                      Set<String> invalidFields = {};
                      bool passwordsDontMatch = false;

                      if (state is ResetPasswordInitial) {
                        invalidFields = state.invalidFields;
                        passwordsDontMatch = !state.passwordsMatch;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
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
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // --- Animated Button ---
            BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
              builder: (context, state) {
                bool isFormValid = false;
                if (state is ResetPasswordInitial) {
                  isFormValid = state.isFormValid;
                }
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  bottom:
                      getKeyboardHeight(context) > 0
                          ? getKeyboardHeight(context) + 8
                          : 40,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        state is ResetPasswordLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ConfirmButton(
                              text: "Lưu thay đổi".tr(),
                              color:
                                  isFormValid
                                      ? const Color(0xFF008080)
                                      : Colors.grey,
                              onPressed: isFormValid ? _handleSubmit : null,
                            ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
