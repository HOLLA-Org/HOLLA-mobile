import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/bloc/forgot_password/send_mail/send_mail_bloc.dart';
import 'package:holla/presentation/bloc/forgot_password/send_mail/send_mail_event.dart';
import 'package:holla/presentation/bloc/forgot_password/send_mail/send_mail_state.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/textfield_custom.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/core/utils/helpers.dart';

class SendMailScreen extends StatefulWidget {
  const SendMailScreen({super.key});

  @override
  State<SendMailScreen> createState() => _SendMailScreenState();
}

class _SendMailScreenState extends State<SendMailScreen> {
  // 1. Declare Controller
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to changes in password fields to validate them
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailController.removeListener(_onEmailChanged);
    super.dispose();
  }

  void _onEmailChanged() {
    context.read<SendMailBloc>().add(
      SendMailEmailChanged(email: _emailController.text),
    );
  }

  // Handle submit button press
  void _handleSubmit() {
    final state = context.read<SendMailBloc>().state;
    if (state is SendMailInitial && state.isFormValid) {
      context.read<SendMailBloc>().add(SendMailSubmitted(email: state.email));
    }
  }

  void _handleSendMailStateChanges(BuildContext context, SendMailState state) {
    if (state is SendMailSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('forgot_password.email_sent'.tr()),
          backgroundColor: const Color(0xFF008080),
        ),
      );
      context.go(AppRoutes.verifypassword, extra: state.email);
    } else if (state is SendMailFailure) {
      notificationDialog(
        context: context,
        title: 'forgot_password.failure'.tr(),
        message: state.error,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SendMailBloc, SendMailState>(
        listener: _handleSendMailStateChanges,
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
                        top: -70.h,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.go(AppRoutes.login);
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
                                'forgot_password.title'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlayfairDisplay',
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'forgot_password.subtitle'.tr(),
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
                  SizedBox(height: 24.h),
                  BlocBuilder<SendMailBloc, SendMailState>(
                    builder: (context, state) {
                      Set<String> invalidFields = {};

                      if (state is SendMailInitial) {
                        invalidFields = state.invalidFields;
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            TextFieldCustom(
                              controller: _emailController,
                              hintText: 'forgot_password.email_hint'.tr(),
                              prefixIcon: Icons.email,
                              hasError: invalidFields.contains('email'),
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
            BlocBuilder<SendMailBloc, SendMailState>(
              builder: (context, state) {
                final isFormValid =
                    (state is SendMailInitial) ? state.isFormValid : false;

                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  bottom:
                      getKeyboardHeight(context) > 0
                          ? getKeyboardHeight(context) + 16.h
                          : 40.h,
                  left: 24.w,
                  right: 24.w,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child:
                        state is SendMailLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ConfirmButton(
                              text: "forgot_password.submit".tr(),
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
