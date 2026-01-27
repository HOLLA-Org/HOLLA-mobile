import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/themes/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionTitle({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: onViewAll,
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'home.view_all'.tr(),
              style: TextStyle(color: AppColors.primary, fontSize: 14.sp),
            ),
          ),
        ),
      ],
    );
  }
}
