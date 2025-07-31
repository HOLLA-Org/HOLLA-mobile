// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Callback for when the privacy policy is tapped.
  void _onPrivacyPolicyTapped(BuildContext context) {
    // navigation privacy policy screen
  }

  // Callback for when the terms of service is tapped.
  void _onTermsOfServiceTapped(BuildContext context) {
    // navigation terms of service screen
  }

  // This will navigate to the loading screen.
  void _onAgreePressed(BuildContext context) {
    context.go(AppRoutes.loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Image(
                    image: AssetImage('assets/logos/onboarding.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'CrimsonText',
                    color: Colors.grey[500],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(text: '${'Đọc'.tr()} '),
                    TextSpan(
                      text: 'Chính sách bảo mật'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () => _onPrivacyPolicyTapped,
                    ),
                    TextSpan(
                      text:
                          '${'. '.tr()}“${'Đồng ý'.tr()}” ${'để chấp nhận'.tr()}\n',
                    ),
                    TextSpan(
                      text: 'Điều khoản dịch vụ'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () => _onTermsOfServiceTapped,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Confirm button
              ConfirmButton(
                text: 'Đồng ý'.tr(),
                onPressed: () => _onAgreePressed(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
