import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'action_button.dart';

class BookingSummaryBottomBar extends StatelessWidget {
  final String checkInLabel;
  final String checkInValue;
  final String checkOutLabel;
  final String checkOutValue;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const BookingSummaryBottomBar({
    super.key,
    required this.checkInLabel,
    required this.checkInValue,
    required this.checkOutLabel,
    required this.checkOutValue,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildSummaryItem(checkInLabel, checkInValue),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "-",
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  ),
                  _buildSummaryItem(checkOutLabel, checkOutValue),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            ActionButton(text: buttonText, onTap: onButtonPressed),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
        ),
      ],
    );
  }
}
