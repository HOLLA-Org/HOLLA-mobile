import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:holla/core/config/themes/app_colors.dart';

class NotificationActionSheet extends StatelessWidget {
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onDeleteAll;
  final bool showMarkAllRead;
  final bool showDeleteAll;

  const NotificationActionSheet({
    super.key,
    this.onMarkAllRead,
    this.onDeleteAll,
    this.showMarkAllRead = false,
    this.showDeleteAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 8.h, bottom: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Divider
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Mark all as read
            if (showMarkAllRead)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                title: Text(
                  'notification.mark_all_read'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackTypo,
                  ),
                ),
                onTap: onMarkAllRead,
              ),

            // Delete all
            if (showDeleteAll)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                title: Text(
                  'notification.delete_all'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackTypo,
                  ),
                ),
                onTap: onDeleteAll,
              ),
          ],
        ),
      ),
    );
  }
}
