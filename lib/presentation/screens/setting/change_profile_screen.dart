import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:holla/core/config/routes/app_routes.dart';
import 'package:holla/presentation/bloc/setting/setting_event.dart';
import 'package:holla/presentation/widget/confirm_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/config/themes/app_colors.dart';
import '../../bloc/setting/setting_bloc.dart';
import '../../bloc/setting/setting_state.dart';
import '../../widget/header_with_back.dart';
import '../../widget/notification_dialog.dart';
import '../../widget/setting/profile_info.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({super.key});

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<SettingBloc>().add(GetUserProfile());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<bool> _checkPermission() async {
    final camera = await Permission.camera.request();
    final storage = await Permission.storage.request();

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final photos = await Permission.photos.request();
        return camera.isGranted && photos.isGranted;
      }
    }

    return storage.isGranted && camera.isGranted;
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('edit_profile.pick_gallery'.tr()),
                  onTap: () {
                    context.pop();
                    _pickFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text('edit_profile.pick_camera'.tr()),
                  onTap: () {
                    context.pop();
                    _pickFromCamera();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickFromGallery() async {
    final granted = await _checkPermission();
    if (!granted) return;

    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    _uploadAvatar(file);
  }

  Future<void> _pickFromCamera() async {
    context.go(AppRoutes.takecamera);
  }

  void _uploadAvatar(XFile file) {
    context.read<SettingBloc>().add(UpdateAvatarSubmitted(filePath: file.path));
  }

  /// Handle back
  void _onBack(BuildContext context) {
    context.go(AppRoutes.setting);
  }

  /// Handle update profile
  void _onUpdateProfile(BuildContext context) {
    context.read<SettingBloc>().add(
      UpdateProfileSubmitted(
        username: _usernameController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: mapGenderToApi(_genderController.text),
        dateOfBirth: _parseDob(_dobController.text),
      ),
    );
  }

  /// Handle update avatar
  void _onEditAvatar(BuildContext context) {
    _showAvatarPicker();
  }

  /// Parse date
  DateTime? _parseDob(String text) {
    if (text.isEmpty) return null;
    try {
      final parts = text.split('/');
      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Pick date of birth
  Future<void> _pickDateOfBirth() async {
    DateTime initialDate = DateTime.now();

    if (_dobController.text.isNotEmpty) {
      try {
        final parts = _dobController.text.split('/');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';
    }
  }

  String mapGenderToApi(String value) {
    if (value == 'edit_profile.male'.tr() ||
        value == 'Nam' ||
        value == 'Male') {
      return 'male';
    }
    if (value == 'edit_profile.female'.tr() ||
        value == 'Nữ' ||
        value == 'Female') {
      return 'female';
    }
    if (value == 'edit_profile.other'.tr() ||
        value == 'Khác' ||
        value == 'Other') {
      return 'other';
    }
    return '';
  }

  String mapGenderToUI(String value) {
    switch (value) {
      case 'male':
        return 'edit_profile.male'.tr();
      case 'female':
        return 'edit_profile.female'.tr();
      case 'other':
        return 'edit_profile.other'.tr();
      default:
        return '';
    }
  }

  /// Pick gender
  Future<void> _pickGender() async {
    final genders = [
      'edit_profile.male'.tr(),
      'edit_profile.female'.tr(),
      'edit_profile.other'.tr(),
    ];

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),

              /// HEADER
              Text(
                'edit_profile.select_gender'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'CrimsonText',
                ),
              ),

              SizedBox(height: 12.h),

              ...genders.map(
                (gender) => ListTile(
                  title: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: 'CrimsonText',
                    ),
                  ),
                  trailing:
                      _genderController.text == gender
                          ? Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: 24.sp,
                          )
                          : null,
                  onTap: () {
                    context.pop(gender);
                  },
                ),
              ),

              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _genderController.text = selected;
      });
    }
  }

  /// Show update profile success
  void showUpdateProfileSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('edit_profile.update_success'.tr()),
        backgroundColor: AppColors.primary,
      ),
    );
    context.go(AppRoutes.setting);
  }

  /// Show update profile failure
  void showUpdateProfileFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'edit_profile.update_failure'.tr(),
      message: error,
      isError: true,
    );
  }

  /// Show update avatar success
  void showUpdateAvatarSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('edit_profile.update_avatar_success'.tr()),
        backgroundColor: AppColors.primary,
      ),
    );
    context.go(AppRoutes.setting);
  }

  /// Show update avatar failure
  void showUpdateAvatarFailure(BuildContext context, String error) {
    notificationDialog(
      context: context,
      title: 'edit_profile.update_failure'.tr(),
      message: error,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is GetUserProfileSuccess) {
          _usernameController.text = state.user.username!;
          _phoneController.text = state.user.phone!;
          _emailController.text = state.user.email!;
          _genderController.text = mapGenderToUI(state.user.gender ?? '');
          final dob = state.user.dateOfBirth;
          _dobController.text = dob == null ? '' : _formatDate(dob);
        }

        if (state is UpdateProfileFailure) {
          showUpdateProfileFailure(context, state.error);
        }

        if (state is UpdateAvatarFailure) {
          showUpdateAvatarFailure(context, state.error);
        }

        if (state is UpdateProfileSuccess) {
          showUpdateProfileSuccess(context);
        }

        if (state is UpdateAvatarSuccess) {
          showUpdateAvatarSuccess(context);
        }
      },
      child: BlocBuilder<SettingBloc, SettingState>(
        buildWhen: (previous, current) {
          return current is GetUserProfileSuccess ||
              current is UpdateProfileSuccess ||
              current is UpdateAvatarSuccess;
        },

        builder: (context, state) {
          if (state is SettingLoading || state is SettingInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = () {
            if (state is GetUserProfileSuccess) {
              return state.user;
            }
            if (state is UpdateProfileSuccess) {
              return state.user;
            }
            if (state is UpdateAvatarSuccess) {
              return state.user;
            }
            return null;
          }();

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: HeaderWithBack(
              title: 'edit_profile.title'.tr(),
              onBack: () => _onBack(context),
              showMore: false,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 16.h),

                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 42.r,
                          backgroundColor: Colors.teal.shade200,
                          backgroundImage:
                              (user != null &&
                                      user.avatarUrl != null &&
                                      user.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                          child:
                              (user == null ||
                                      user.avatarUrl == null ||
                                      user.avatarUrl!.isEmpty)
                                  ? Icon(
                                    Icons.pets,
                                    size: 36.sp,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),

                        // Edit icon (bottom right)
                        Positioned(
                          right: -2.w,
                          bottom: -2.h,
                          child: GestureDetector(
                            onTap: () => _onEditAvatar(context),
                            child: Container(
                              width: 28.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Name
                  ProfileInfoRow(
                    label: 'edit_profile.username'.tr(),
                    controller: _usernameController,
                  ),

                  // Phone
                  ProfileInfoRow(
                    label: 'edit_profile.phone'.tr(),
                    controller: _phoneController,
                  ),

                  // Email
                  ProfileInfoRow(
                    label: 'edit_profile.email'.tr(),
                    controller: _emailController,
                    readOnly: true,
                  ),

                  SizedBox(height: 16.h),

                  // Section title
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'edit_profile.personal_info'.tr(),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'CrimsonText',
                          color: AppColors.blackTypo,
                        ),
                      ),
                    ),
                  ),

                  // Gender
                  ProfileInfoRow(
                    label: 'edit_profile.gender'.tr(),
                    controller: _genderController,
                    readOnly: true,
                    suffixIcon: LucideIcons.chevronDown,
                    onSuffixTap: () => _pickGender(),
                  ),

                  // Date of birth
                  ProfileInfoRow(
                    label: 'edit_profile.dob'.tr(),
                    controller: _dobController,
                    readOnly: true,
                    suffixIcon: Icons.calendar_today,
                    onSuffixTap: () => _pickDateOfBirth(),
                  ),

                  const Spacer(),

                  // Update button
                  Padding(
                    padding: EdgeInsets.only(bottom: 60.h),
                    child: Center(
                      child: ConfirmButton(
                        text: 'edit_profile.update_button'.tr(),
                        onPressed: () => _onUpdateProfile(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
