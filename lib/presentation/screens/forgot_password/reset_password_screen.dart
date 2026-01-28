import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          content: Text('reset_password.success'.tr()),
          backgroundColor: const Color(0xFF008080),
        ),
      );
      context.go(AppRoutes.login);
    } else if (state is ResetPasswordFailure) {
      notificationDialog(
        context: context,
        title: 'reset_password.failure'.tr(),
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
                        image: const AssetImage(
                          'assets/images/main/main_elip.png',
                        ),
                        width: double.infinity,
                        height: 300.h,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        top: -70.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 36.sp,
                                  color: Colors.white,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(right: 16.w),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'reset_password.title'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlayfairDisplay',
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'reset_password.subtitle'.tr(),
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

                  SizedBox(height: 30.h),

                  BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                    builder: (context, state) {
                      Set<String> invalidFields = {};
                      bool passwordsDontMatch = false;

                      if (state is ResetPasswordInitial) {
                        invalidFields = state.invalidFields;
                        passwordsDontMatch = !state.passwordsMatch;
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            TextFieldCustom(
                              controller: _passwordController,
                              hintText:
                                  'reset_password.new_password_label'.tr(),
                              prefixIcon: Icons.lock,
                              isPassword: true,
                              hasError:
                                  passwordsDontMatch ||
                                  invalidFields.contains('password'),
                            ),
                            SizedBox(height: 10.h),
                            TextFieldCustom(
                              controller: _confirmPasswordController,
                              hintText:
                                  'reset_password.confirm_new_password_label'
                                      .tr(),
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
                          ? getKeyboardHeight(context) + 8.h
                          : 40.h,
                  left: 24.w,
                  right: 24.w,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child:
                        state is ResetPasswordLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ConfirmButton(
                              text: "reset_password.submit".tr(),
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
