import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/bloc/setting/setting_bloc.dart';
import 'package:holla/bloc/setting/setting_event.dart';
import 'package:holla/bloc/setting/setting_state.dart';
import 'package:holla/presentation/widget/confirm_dialog.dart';
import 'package:holla/presentation/widget/header.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/setting_title.dart';
import 'package:holla/routes/app_routes.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  void _onLanguageTap(BuildContext context) {
    context.go(AppRoutes.language);
  }

  void _onPolicyTap() {
    // navigation policy screen
  }

  void _onSupportTap() {
    // navigation support screen
  }

  void _onTermsTap() {
    // navigation terms screen
  }

  void _onLogoutTap(BuildContext context) {
    showConfirmDialog(
      context: context,
      title: 'Xác nhận',
      content: 'Bạn có chắc chắn muốn đăng xuất?',
      confirmText: 'Có',
      cancelText: 'Không',
      onConfirm: () {
        context.read<SettingBloc>().add(LogoutRequested());
      },
    );
  }

  String getLanguageName(BuildContext context) {
    final locale = context.locale.languageCode;
    switch (locale) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return locale;
    }
  }

  void showLogoutSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đăng xuất thành công!'.tr()),
        backgroundColor: const Color(0xFF008080),
      ),
    );
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }

  void showLogoutFailure(BuildContext context, String error) {
    if (context.mounted) {
      notificationDialog(
        context: context,
        title: 'Đăng xuất thất bại'.tr(),
        message: error,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          showLogoutSuccess(context);
        } else if (state is LogoutFailure) {
          showLogoutFailure(context, state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  child: ListView(
                    children: [
                      Text(
                        'Tổng quan'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'CrimsonText'.tr(),
                          color: Color(0xFF8F8F8F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SettingTile(
                        icon: LucideIcons.languages,
                        title: 'Ngôn ngữ'.tr(),
                        trailing: Text(
                          getLanguageName(context),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8F8F8F),
                            fontFamily: 'CrimsonText',
                            fontSize: 16,
                          ),
                        ),
                        onTap: () => _onLanguageTap(context),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Khác'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8F8F8F),
                          fontFamily: 'CrimsonText',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SettingTile(
                        icon: LucideIcons.lock,
                        title: 'Chính sách bảo mật'.tr(),
                        onTap: _onPolicyTap,
                      ),
                      SettingTile(
                        icon: LucideIcons.helpCircle,
                        title: 'Hỗ trợ khách hàng'.tr(),
                        onTap: _onSupportTap,
                      ),
                      SettingTile(
                        icon: LucideIcons.shieldCheck,
                        title: 'Điều khoản dịch vụ'.tr(),
                        onTap: _onTermsTap,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hành động'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8F8F8F),
                          fontFamily: 'CrimsonText',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Đăng xuất'.tr(),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => _onLogoutTap(context),
                          ),
                        ),
                      ),
                    ],
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
