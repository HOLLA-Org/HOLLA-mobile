import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/themes/app_colors.dart';

class EmptyList extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const EmptyList({
    super.key,
    this.title = 'home.no_hotels',
    this.subtitle = 'home.no_hotels_message',
    this.imagePath = 'assets/images/search/not_found_hotel.png',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          SizedBox(
            width: 160.w,
            height: 160.h,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          SizedBox(height: 16.h),

          // Title
          Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),

          // Subtitle
          Text(
            subtitle.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blackTypo,
            ),
          ),

          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}
