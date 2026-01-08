// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';

import 'package:holla/core/config/themes/app_colors.dart';
import '../../widget/confirm_button.dart';
import '../../widget/header_with_back.dart';
import '../../widget/input_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  /// ===== Controllers =====
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// ===== Error flags =====
  bool _hasCurrentPassError = false;
  bool _hasNewPassError = false;
  bool _hasConfirmPassError = false;

  bool _isLoading = false;

  /// ===== VALIDATION =====
  String? get _currentPasswordErrorText {
    if (_currentPasswordController.text.isEmpty) {
      return 'Vui lòng nhập mật khẩu hiện tại';
    }
    return null;
  }

  String? get _newPasswordErrorText {
    final text = _newPasswordController.text;
    if (text.isEmpty) return null;

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

  String? get _confirmPasswordErrorText {
    if (_confirmPasswordController.text.isEmpty) {
      return 'Vui lòng nhập lại mật khẩu mới';
    }
    if (_confirmPasswordController.text != _newPasswordController.text) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  bool get _isValid =>
      _currentPasswordErrorText == null &&
      _newPasswordErrorText == null &&
      _confirmPasswordErrorText == null &&
      _currentPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  /// ===== ACTIONS =====
  void _onBack(BuildContext context) {
    context.go(AppRoutes.setting);
  }

  Future<void> _onSubmit(BuildContext context) async {
    setState(() {
      _hasCurrentPassError = _currentPasswordErrorText != null;
      _hasNewPassError = _newPasswordErrorText != null;
      _hasConfirmPassError = _confirmPasswordErrorText != null;
    });

    if (!_isValid) return;

    setState(() => _isLoading = true);

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Đổi mật khẩu thành công'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đổi mật khẩu thất bại'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWithBack(
        title: 'Đổi mật khẩu',
        onBack: () => _onBack(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// ===== CONTENT =====
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  const SizedBox(height: 12),

                  /// CURRENT PASSWORD
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

                  /// NEW PASSWORD
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

                  /// CONFIRM PASSWORD
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

            /// ===== SUBMIT BUTTON =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ConfirmButton(
                text: 'Xác nhận',
                onPressed:
                    (!_isLoading && _isValid) ? () => _onSubmit(context) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
