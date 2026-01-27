import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:holla/core/config/themes/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final FontWeight? fontWeight;

  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.padding,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: (fontSize ?? 16).sp,
            fontWeight: fontWeight,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
