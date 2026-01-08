// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';

import 'package:holla/core/config/themes/app_colors.dart';
import 'package:holla/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_state.dart';
import '../../bloc/setting/setting_event.dart';
import '../../widget/confirm_button.dart';
import '../../widget/header_with_back.dart';
import '../../widget/input_textfield.dart';
import '../../widget/notification_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  /// Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Error flags
  bool _hasCurrentPassError = false;
  bool _hasNewPassError = false;
  bool _hasConfirmPassError = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _currentPasswordController.addListener(() {
      setState(() {
        _hasCurrentPassError = _currentPasswordErrorText != null;
      });
    });

    _newPasswordController.addListener(() {
      setState(() {
        _hasNewPassError = _newPasswordErrorText != null;
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        _hasConfirmPassError = _confirmPasswordErrorText != null;
      });
    });
  }

  /// Get current password error text
  String? get _currentPasswordErrorText {
    final text = _currentPasswordController.text;

    if (text.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại';

    if (text.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'Mật khẩu phải chứa chữ thường';
    }
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'Mật khẩu phải chứa chữ hoa';
    }
    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'Mật khẩu phải chứa ký tự đặc biệt';
    }
    return null;
  }

  /// Get new password error text
  String? get _newPasswordErrorText {
    final text = _newPasswordController.text;
    if (text.isEmpty) return 'Vui lòng nhập mật khẩu mới';

    if (text.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'Mật khẩu phải chứa chữ thường';
    }
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'Mật khẩu phải chứa chữ hoa';
    }
    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'Mật khẩu phải chứa ký tự đặc biệt';
    }
    return null;
  }

  /// Get confirm password error text
  String? get _confirmPasswordErrorText {
    final text = _confirmPasswordController.text;
    if (text.isEmpty) return 'Vui lòng nhập lại mật khẩu mới';
    if (text != _newPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  /// Handle validate
  bool get _isValid =>
      _currentPasswordErrorText == null &&
      _newPasswordErrorText == null &&
      _confirmPasswordErrorText == null &&
      _currentPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  /// Handle back
  void _onBack(BuildContext context) {
    context.go(AppRoutes.setting);
  }

  /// Handle change password
  Future<void> _onSubmit(BuildContext context) async {
    if (!_isValid) return;

    context.read<SettingBloc>().add(
      ChangePasswordSubmitted(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  /// Handle change password success
  void showChangePasswordSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đổi mật khẩu thành công!'),
        backgroundColor: AppColors.primary,
      ),
    );
    context.go(AppRoutes.setting);
  }

  /// Handle change password failure
  void showChangePasswordFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'Đổi mật khẩu thất bại',
      message: error,
      isError: true,
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingLoading) {
          setState(() => _isLoading = true);
        }

        if (state is ChangePasswordSuccess) {
          setState(() => _isLoading = false);
          showChangePasswordSuccess(context);
        }

        if (state is ChangePasswordFailure) {
          setState(() => _isLoading = false);
          showChangePasswordFailure(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: HeaderWithBack(
          title: 'Đổi mật khẩu',
          onBack: () => _onBack(context),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  children: [
                    const SizedBox(height: 12),

                    // Current password
                    const Text(
                      'Mật khẩu hiện tại',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodyTypo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputTextField(
                      controller: _currentPasswordController,
                      isPassword: true,
                      hasError: _hasCurrentPassError,
                      errorText: _currentPasswordErrorText,
                    ),

                    const SizedBox(height: 16),

                    // New password
                    const Text(
                      'Mật khẩu mới',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodyTypo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputTextField(
                      controller: _newPasswordController,
                      isPassword: true,
                      hasError: _hasNewPassError,
                      errorText: _newPasswordErrorText,
                    ),

                    const SizedBox(height: 16),

                    // Confirm password
                    const Text(
                      'Xác nhận mật khẩu mới',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodyTypo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    InputTextField(
                      controller: _confirmPasswordController,
                      isPassword: true,
                      hasError: _hasConfirmPassError,
                      errorText: _confirmPasswordErrorText,
                    ),
                  ],
                ),
              ),

              // Submit button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ConfirmButton(
                    text: 'Đổi mật khẩu',
                    onPressed:
                        (!_isLoading && _isValid)
                            ? () => _onSubmit(context)
                            : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
