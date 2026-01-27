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
import '../../../models/user_model.dart';
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
    context.push(AppRoutes.language);
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
      title: 'setting.logout_confirm_title'.tr(),
      content: 'setting.logout_confirm_content'.tr(),
      confirmText: 'setting.logout_confirm_yes'.tr(),
      cancelText: 'setting.logout_confirm_no'.tr(),
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
        return 'setting.english'.tr();
      case 'vi':
        return 'setting.vietnamese'.tr();
      default:
        return locale;
    }
  }

  /// Show logout success
  void showLogoutSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('setting.success'.tr()),
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
        title: 'login.failure'.tr(),
        message: error,
        isError: true,
      );
    }
  }

  /// Show update profile success
  void showUpdateProfileSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('edit_profile.update_success'.tr()),
        backgroundColor: const Color(0xFF008080),
      ),
    );
  }

  /// Show update profile failure
  void showUpdateProfileFailure(BuildContext context, String error) {
    if (context.mounted) {
      notificationDialog(
        context: context,
        title: 'edit_profile.update_failure'.tr(),
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
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        } else if (state is UpdateProfileSuccess) {
          showUpdateProfileSuccess(context);
        } else if (state is UpdateProfileFailure) {
          showUpdateProfileFailure(context, state.error);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              UserModel? user;
              if (state is GetUserProfileSuccess) {
                user = state.user;
              } else if (state is UpdateProfileSuccess) {
                user = state.user;
              } else if (state is UpdateAvatarSuccess) {
                user = state.user;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingProfileHeader(
                    name: user?.username ?? 'Joy',
                    email: user?.email ?? 'joy@holla.com',
                    avatarUrl: user?.avatarUrl,
                    onEditTap: () => _onProfileTap(context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12,
                      ),
                      child: ListView(
                        children: [
                          SettingSectionTitle('setting.settings_section'.tr()),
                          SettingTile(
                            icon: LucideIcons.settings,
                            title: 'setting.account_setup'.tr(),
                            onTap: () => _onChangePasswordTap(context),
                          ),
                          SettingTile(
                            icon: LucideIcons.bell,
                            title: 'setting.notification'.tr(),
                            onTap: () => _onNotificationTap(context),
                          ),
                          SettingTile(
                            icon: LucideIcons.languages,
                            title: 'setting.language'.tr(),
                            trailing: Text(getLanguageName(context)),
                            onTap: () => _onLanguageTap(context),
                          ),
                          SettingTile(
                            icon: LucideIcons.mapPin,
                            title: 'setting.location'.tr(),
                            trailing: Text(
                              (user?.locationName != null &&
                                      user!.locationName!.isNotEmpty)
                                  ? user.locationName!
                                  : '',
                            ),
                          ),
                          SettingSectionTitle('setting.info_section'.tr()),
                          SettingTile(
                            icon: LucideIcons.helpCircle,
                            title: 'setting.faqs'.tr(),
                          ),
                          SettingTile(
                            icon: LucideIcons.shieldCheck,
                            title: 'setting.terms_policies'.tr(),
                          ),
                          SettingTile(
                            icon: LucideIcons.info,
                            title: 'setting.app_version'.tr(),
                            trailing: const Text('1.0'),
                          ),
                          SettingTile(
                            icon: LucideIcons.phone,
                            title: 'setting.contact'.tr(),
                          ),
                          SettingTile(
                            icon: LucideIcons.logOut,
                            title: 'setting.logout'.tr(),
                            showDivider: false,
                            onTap: () => _onLogoutTap(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
