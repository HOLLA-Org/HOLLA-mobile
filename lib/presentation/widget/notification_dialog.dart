import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> notificationDialog({
  required BuildContext context,
  required String title,
  required String message,
  bool isError = false,
  VoidCallback? onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
            color: isError ? Colors.red : const Color(0xFF008080),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'CrimsonText',
              color: Colors.grey[600],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'common.agree'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}
