import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:holla/core/config/themes/app_colors.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 4.w,
              top: 16.h,
              bottom: 4.h,
            ),
            child: Row(
              children: [
                Icon(icon, size: 22.sp, color: Colors.black87),
                SizedBox(width: 12.w),

                /// TITLE
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontFamily: 'CrimsonText',
                    ),
                  ),
                ),

                /// TRAILING
                if (trailing != null) ...[
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTypo,
                      fontFamily: 'CrimsonText',
                    ),
                    child: trailing!,
                  ),
                ],
              ],
            ),
          ),

          /// DIVIDER
          if (showDivider)
            Divider(
              height: 1.h,
              thickness: 0.8.h,
              indent: 50.w,
              color: Colors.grey.shade300,
            ),
        ],
      ),
    );
  }
}
