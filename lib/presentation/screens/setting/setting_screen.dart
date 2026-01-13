import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/presentation/bloc/setting/setting_bloc.dart';
import 'package:holla/presentation/bloc/setting/setting_event.dart';
import 'package:holla/presentation/bloc/setting/setting_state.dart';
import 'package:holla/presentation/widget/confirm_dialog.dart';
import 'package:holla/presentation/widget/notification_dialog.dart';
import 'package:holla/presentation/widget/setting/setting_title.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widget/setting/setting_profile_header.dart';
import '../../widget/setting/setting_section_title.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();

    context.read<SettingBloc>().add(GetUserProfile());
  }

  /// Handle language
  void _onLanguageTap(BuildContext context) {
    context.go(AppRoutes.language);
  }

  // void _onPolicyTap() {
  //   // navigation policy screen
  // }

  // void _onSupportTap() {
  //   // navigation support screen
  // }

  // void _onTermsTap() {
  //   // navigation terms screen
  // }

  /// Handle change password
  void _onChangePasswordTap(BuildContext context) {
    context.go(AppRoutes.changepassword);
  }

  /// Handle notification
  void _onNotificationTap(BuildContext context) {
    context.push(AppRoutes.notification);
  }

  /// Handle edit profile
  void _onProfileTap(BuildContext context) {
    context.go(AppRoutes.changeprofile);
  }

  /// Handle logout
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

  /// Get language name
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

  /// Show logout success
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

  /// Show logout failure
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

  /// Show update profile success
  void showUpdateProfileSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cập nhật thông tin thành công!'.tr()),
        backgroundColor: const Color(0xFF008080),
      ),
    );
  }

  /// Show update profile failure
  void showUpdateProfileFailure(BuildContext context, String error) {
    if (context.mounted) {
      notificationDialog(
        context: context,
        title: 'Cập nhật thông tin thất bại'.tr(),
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
        } else if (state is UpdateProfileSuccess) {
          showUpdateProfileSuccess(context);
        } else if (state is UpdateProfileFailure) {
          showUpdateProfileFailure(context, state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SettingBloc, SettingState>(
                builder: (context, state) {
                  if (state is GetUserProfileSuccess) {
                    final user = state.user;

                    return SettingProfileHeader(
                      name: user.username,
                      email: user.email,
                      avatarUrl: user.avatarUrl,
                      onEditTap: () => _onProfileTap(context),
                    );
                  }

                  return const SettingProfileHeader(name: '---', email: '---');
                },
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  child: ListView(
                    children: [
                      SettingSectionTitle('Cài đặt'.tr()),

                      SettingTile(
                        icon: LucideIcons.settings,
                        title: 'Thiết lập tài khoản'.tr(),
                        onTap: () => _onChangePasswordTap(context),
                      ),

                      SettingTile(
                        icon: LucideIcons.bell,
                        title: 'Thông báo'.tr(),
                        onTap: () => _onNotificationTap(context),
                      ),

                      SettingTile(
                        icon: LucideIcons.languages,
                        title: 'Ngôn ngữ'.tr(),
                        trailing: Text(getLanguageName(context)),
                        onTap: () => _onLanguageTap(context),
                      ),

                      SettingTile(
                        icon: LucideIcons.mapPin,
                        title: 'Khu vực'.tr(),
                        trailing: const Text('Hà Nội'),
                      ),

                      /// ===== THÔNG TIN =====
                      SettingSectionTitle('Thông tin'.tr()),

                      SettingTile(
                        icon: LucideIcons.helpCircle,
                        title: 'Hỏi đáp'.tr(),
                      ),

                      SettingTile(
                        icon: LucideIcons.shieldCheck,
                        title: 'Điều khoản & chính sách bảo mật'.tr(),
                      ),

                      SettingTile(
                        icon: LucideIcons.info,
                        title: 'Phiên bản'.tr(),
                        trailing: const Text('1.0'),
                      ),

                      SettingTile(
                        icon: LucideIcons.phone,
                        title: 'Liên hệ'.tr(),
                      ),

                      SettingTile(
                        icon: LucideIcons.logOut,
                        title: 'Đăng xuất'.tr(),
                        showDivider: false,
                        onTap: () => _onLogoutTap(context),
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
