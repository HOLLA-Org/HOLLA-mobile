import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_circle.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class NotificationSkeleton extends StatelessWidget {
  const NotificationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon skeleton
                const SkeletonCircle(size: 48),
                SizedBox(width: 12.w),
                // Content skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      SkeletonLine(width: 150.w, height: 16.h),
                      SizedBox(height: 8.h),
                      // Content
                      SkeletonLine(width: double.infinity, height: 14.h),
                      SizedBox(height: 4.h),
                      SkeletonLine(width: 200.w, height: 14.h),
                      SizedBox(height: 8.h),
                      // Time
                      SkeletonLine(width: 80.w, height: 12.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
