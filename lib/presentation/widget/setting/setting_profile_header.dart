import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/config/themes/app_colors.dart';

class SettingProfileHeader extends StatelessWidget {
  final String? name;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onEditTap;

  const SettingProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// AVATAR
          CircleAvatar(
            radius: 28.r,
            backgroundColor: const Color(0xFFD9D9D9),
            backgroundImage:
                avatarUrl != null && avatarUrl!.isNotEmpty
                    ? NetworkImage(avatarUrl!)
                    : const AssetImage('assets/images/avatar/avatar.jpg'),
          ),

          SizedBox(width: 12.w),

          /// NAME + EMAIL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null)
                  Text(
                    name!,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      fontFamily: 'CrimsonText',
                    ),
                  ),

                Row(
                  children: [
                    if (email != null)
                      Expanded(
                        child: Text(
                          email!,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.white.withOpacity(0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    InkWell(
                      onTap: onEditTap,
                      child: Icon(
                        LucideIcons.edit,
                        size: 18.sp,
                        color: const Color(0xFF68E1FD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
