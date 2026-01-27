import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/themes/app_colors.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final bool showDivider;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.showDivider = true,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: 8.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// LABEL (LEFT)
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'CrimsonText',
                    color: AppColors.blackTypo,
                  ),
                ),
              ),

              /// VALUE + BUTTON (RIGHT)
              SizedBox(
                width: 200.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// TEXT
                    Expanded(
                      child: TextField(
                        controller: controller,
                        readOnly: readOnly,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'CrimsonText',
                          color:
                              readOnly
                                  ? AppColors.disableTypo
                                  : AppColors.blackTypo,
                        ),
                      ),
                    ),

                    /// BUTTON / ICON
                    if (suffixIcon != null) ...[
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: onSuffixTap,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Icon(
                          suffixIcon,
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(
            height: 1.h,
            thickness: 0.8.h,
            indent: 16.w,
            endIndent: 16.w,
            color: Colors.grey.shade300,
          ),
      ],
    );
  }
}
