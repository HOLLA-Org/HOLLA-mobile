import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/bloc/forgot_password/verify_pass/verify_password_bloc.dart';
import 'package:holla/bloc/forgot_password/verify_pass/verify_password_event.dart';
import 'package:holla/bloc/forgot_password/verify_pass/verify_password_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/routes/app_routes.dart';
import 'package:holla/utils/util.dart';
import 'package:pinput/pinput.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';

class VerifyPasswordScreen extends StatefulWidget {
  final String email;

  const VerifyPasswordScreen({super.key, required this.email});

  @override
  State<VerifyPasswordScreen> createState() => _VerifyPasswordScreenState();
}

class _VerifyPasswordScreenState extends State<VerifyPasswordScreen> {
  // Controllers and state variables for the screen
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _timer;
  int _start = 60;

  // Default styling for the OTP input fields
  final _defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400),
    ),
  );

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // Starts or resets the countdown timer for the "Resend Code" button
  void startTimer() {
    setState(() => _start = 300);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  // Notifies the BLoC that the entered code has changed
  void _onCodeChanged(String code) {
    context.read<VerifyPasswordBloc>().add(
      VerifyPasswordCodeChanged(code: code),
    );
  }

  // Dispatches an event to submit the verification code
  void _handleVerifyPassword() {
    if (_pinController.text.length == 6) {
      context.read<VerifyPasswordBloc>().add(
        VerifyPasswordSubmitted(email: widget.email, code: _pinController.text),
      );
    }
  }

  // Dispatches an event to request a new verification code
  void _handleResendCode() {
    context.read<VerifyPasswordBloc>().add(
      VerifyPasswordResendCode(email: widget.email),
    );
    startTimer();
  }

  // Handles state changes from the [VerifyPasswordBloc] to show UI feedback
  void _handleStateChanges(BuildContext context, VerifyPasswordState state) {
    if (state is VerifyPasswordSuccess) {
      context.go(AppRoutes.resetpassword, extra: state.token);
    } else if (state is VerifyPasswordFailure) {
      notificationDialog(
        context: context,
        title: 'Thất bại'.tr(),
        message: state.error,
        isError: true,
      );
    } else if (state is VerifyPasswordCodeResent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mã xác thực mới đã được gửi.'.tr(),
            style: TextStyle(fontSize: 16, fontFamily: 'CrimsonText'),
          ),
          backgroundColor: Color(0xFF008080),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<VerifyPasswordBloc, VerifyPasswordState>(
        listener: _handleStateChanges,
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
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        top: -60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.go(AppRoutes.sendmail);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 36,
                                  color: Colors.white,
                                ),

                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(right: 16.0),
                              ),
                              Text(
                                'Quên mật khẩu'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlayfairDisplay',
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nhập mã của bạn để lấy lại mật khẩu'.tr(),
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

                  const SizedBox(height: 50),

                  // --- OTP Input & Resend Section ---
                  BlocBuilder<VerifyPasswordBloc, VerifyPasswordState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            // Pinput widget for OTP entry
                            Pinput(
                              length: 6,
                              controller: _pinController,
                              focusNode: _focusNode,
                              onChanged: _onCodeChanged,
                              defaultPinTheme: _defaultPinTheme,
                              focusedPinTheme: _defaultPinTheme.copyWith(
                                decoration: _defaultPinTheme.decoration!
                                    .copyWith(
                                      border: Border.all(
                                        color: const Color(0xFF008080),
                                      ),
                                    ),
                              ),
                              submittedPinTheme: _defaultPinTheme.copyWith(
                                decoration: _defaultPinTheme.decoration!
                                    .copyWith(
                                      border: Border.all(
                                        color: const Color(0xFF008080),
                                      ),
                                    ),
                              ),
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 20),

                            // "Resend Code" button and countdown timer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed:
                                      _start == 0 ? _handleResendCode : null,
                                  child: Text(
                                    'Gửi lại mã'.tr(),
                                    style: TextStyle(
                                      color:
                                          _start == 0
                                              ? const Color(0xFF008080)
                                              : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'CrimsonText',
                                    ),
                                  ),
                                ),

                                // Display the countdown timer if it's running
                                if (_start > 0)
                                  Builder(
                                    builder: (context) {
                                      final minutes = (_start ~/ 60)
                                          .toString()
                                          .padLeft(2, '0');
                                      final seconds = (_start % 60)
                                          .toString()
                                          .padLeft(2, '0');
                                      return Text(
                                        '$minutes:$seconds',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                              ],
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
            BlocBuilder<VerifyPasswordBloc, VerifyPasswordState>(
              builder: (context, state) {
                final isFormValid = state.isFormValid;

                // Animate the button's position to avoid being covered by the keyboard
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  bottom:
                      getKeyboardHeight(context) > 0
                          ? getKeyboardHeight(context)
                          : 40,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        state is VerifyPasswordLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ConfirmButton(
                              text: "Xác nhận".tr(),
                              color:
                                  isFormValid
                                      ? const Color(0xFF008080)
                                      : Colors.grey,
                              onPressed:
                                  isFormValid ? _handleVerifyPassword : null,
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
