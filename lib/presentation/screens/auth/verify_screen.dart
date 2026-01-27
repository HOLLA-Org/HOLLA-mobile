import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:holla/presentation/bloc/auth/verify/verify_bloc.dart';
import 'package:holla/presentation/bloc/auth/verify/verify_event.dart';
import 'package:holla/presentation/bloc/auth/verify/verify_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/core/utils/helpers.dart';
import 'package:pinput/pinput.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // Controllers and state variables for the screen
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _timer;
  int _start = 60;

  // Default styling for the OTP input fields
  final _defaultPinTheme = PinTheme(
    width: 56.w,
    height: 56.h,
    textStyle: TextStyle(
      fontSize: 22.sp,
      color: const Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
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
    context.read<VerifyBloc>().add(VerifyCodeChanged(code: code));
  }

  // Dispatches an event to submit the verification code
  void _handleVerify() {
    if (_pinController.text.length == 6) {
      context.read<VerifyBloc>().add(
        VerifySubmitted(email: widget.email, code: _pinController.text),
      );
    }
  }

  // Dispatches an event to request a new verification code
  void _handleResendCode() {
    context.read<VerifyBloc>().add(VerifyResendCode(email: widget.email));
    startTimer();
  }

  // Handles state changes from the [VerifyBloc] to show UI feedback
  void _handleStateChanges(BuildContext context, VerifyState state) {
    if (state is VerifySuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'verify.success'.tr(),
            style: TextStyle(fontSize: 16.sp, fontFamily: 'CrimsonText'),
          ),
          backgroundColor: const Color(0xFF008080),
        ),
      );
      context.go(AppRoutes.login);
    } else if (state is VerifyFailure) {
      notificationDialog(
        context: context,
        title: 'verify.failure'.tr(),
        message: state.error,
        isError: true,
      );
    } else if (state is VerifyCodeResent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'verify.resend_success'.tr(),
            style: TextStyle(fontSize: 16.sp, fontFamily: 'CrimsonText'),
          ),
          backgroundColor: const Color(0xFF008080),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<VerifyBloc, VerifyState>(
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
                        height: 300.h,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        top: -60.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'verify.title'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlayfairDisplay',
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'verify.subtitle'.tr(),
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

                  SizedBox(height: 50.h),

                  // --- OTP Input & Resend Section ---
                  BlocBuilder<VerifyBloc, VerifyState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
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

                            SizedBox(height: 20.h),

                            // "Resend Code" button and countdown timer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed:
                                      _start == 0 ? _handleResendCode : null,
                                  child: Text(
                                    'verify.resend'.tr(),
                                    style: TextStyle(
                                      color:
                                          _start == 0
                                              ? const Color(0xFF008080)
                                              : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
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
            BlocBuilder<VerifyBloc, VerifyState>(
              builder: (context, state) {
                final isFormValid = state.isFormValid;

                // Animate the button's position to avoid being covered by the keyboard
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  bottom:
                      getKeyboardHeight(context) > 0
                          ? getKeyboardHeight(context)
                          : 40.h,
                  left: 24.w,
                  right: 24.w,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child:
                        state is VerifyLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ConfirmButton(
                              text: "verify.submit".tr(),
                              color:
                                  isFormValid
                                      ? const Color(0xFF008080)
                                      : Colors.grey,
                              onPressed: isFormValid ? _handleVerify : null,
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
