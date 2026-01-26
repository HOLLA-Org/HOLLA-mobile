// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
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

    if (text.isEmpty) return 'validation.current_password_required'.tr();

    if (text.length < 8) {
      return 'validation.password_min_length'.tr();
    }
    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'validation.password_lowercase'.tr();
    }
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'validation.password_uppercase'.tr();
    }
    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'validation.password_special_char'.tr();
    }
    return null;
  }

  /// Get new password error text
  String? get _newPasswordErrorText {
    final text = _newPasswordController.text;
    if (text.isEmpty) {
      return 'validation.password_required'.tr();
    }

    if (text.length < 8) {
      return 'validation.password_min_length'.tr();
    }
    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'validation.password_lowercase'.tr();
    }
    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'validation.password_uppercase'.tr();
    }
    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'validation.password_special_char'.tr();
    }
    return null;
  }

  /// Get confirm password error text
  String? get _confirmPasswordErrorText {
    final text = _confirmPasswordController.text;
    if (text.isEmpty) return 'validation.confirm_password_required'.tr();
    if (text != _newPasswordController.text) {
      return 'validation.password_not_match'.tr();
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
      SnackBar(
        content: Text('change_password.success_message'.tr()),
        backgroundColor: AppColors.primary,
      ),
    );
    context.go(AppRoutes.setting);
  }

  /// Handle change password failure
  void showChangePasswordFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'change_password.failure_message'.tr(),
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
          title: 'change_password.title'.tr(),
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
                    Text(
                      'change_password.current'.tr(),
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
                    Text(
                      'change_password.new'.tr(),
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
                    Text(
                      'change_password.confirm'.tr(),
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
                    text: 'change_password.submit_button'.tr(),
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
