import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class SettingSectionTitle extends StatelessWidget {
  final String title;

  const SettingSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, top: 12.h, right: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'CrimsonText',
        ),
      ),
    );
  }
}
