import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/config/themes/app_colors.dart';

class NotificationItem extends StatelessWidget {
  final String id;
  final String title;
  final String? content;
  final DateTime createdAt;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationItem({
    super.key,
    required this.id,
    required this.title,
    required this.createdAt,
    this.content,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 32.w,
                height: 32.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4F3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mail, size: 16.sp, color: AppColors.primary),
              ),

              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTypo,
                              height: 1.2,
                              fontFamily: 'CrimsonText',
                            ),
                          ),
                        ),

                        // More
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: PopupMenuButton(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.more_vert,
                                size: 16.sp,
                                color: AppColors.disableTypo,
                              ),
                              itemBuilder:
                                  (_) => [
                                    PopupMenuItem<String>(
                                      height: 4.h,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                      ),
                                      value: 'delete',
                                      child: Center(
                                        child: Text(
                                          'Xoá',
                                          style: TextStyle(
                                            color: AppColors.error,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                              onSelected: (value) {
                                if (value == 'delete') {
                                  onDelete!();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Content
                    Text(
                      content ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.disableTypo,
                        fontFamily: 'CrimsonText',
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Time
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.disableTypo,
                          fontFamily: 'CrimsonText',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
