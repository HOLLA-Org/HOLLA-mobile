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
          content: Text('Yêu cầu đã được gửi, vui lòng kiểm tra email!'.tr()),
          backgroundColor: Color(0xFF008080),
        ),
      );
      context.go(AppRoutes.verifypassword, extra: state.email);
    } else if (state is SendMailFailure) {
      notificationDialog(
        context: context,
        title: 'Yêu cầu thất bại'.tr(),
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
                                  context.go(AppRoutes.login);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 36,
                                  color: Colors.white,
                                ),

                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(right: 16.0),
                              ),
                              SizedBox(height: 4),
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
                                'Nhập email liên kết với tài khoản để \nlấy lại mật khẩu'
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
                  const SizedBox(height: 50),
                  BlocBuilder<SendMailBloc, SendMailState>(
                    builder: (context, state) {
                      Set<String> invalidFields = {};

                      if (state is SendMailInitial) {
                        invalidFields = state.invalidFields;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            TextFieldCustom(
                              controller: _emailController,
                              hintText: 'example@gmail.com',
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
                          ? getKeyboardHeight(context) + 16
                          : 40,
                  left: 24,
                  right: 24,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child:
                        state is SendMailLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ConfirmButton(
                              text: "Gửi mã".tr(),
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
