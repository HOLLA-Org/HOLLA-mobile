import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_circle.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Avatar
          const Center(child: SkeletonCircle(size: 84)),
          SizedBox(height: 24.h),
          // Info rows
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // Username Row
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 80.w, height: 16.h),
                      SkeletonLine(width: 150.w, height: 16.h),
                    ],
                  ),
                ),
                // Phone Row
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 80.w, height: 16.h),
                      SkeletonLine(width: 150.w, height: 16.h),
                    ],
                  ),
                ),
                // Email Row
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 80.w, height: 16.h),
                      SkeletonLine(width: 150.w, height: 16.h),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Section title
                Align(
                  alignment: Alignment.centerLeft,
                  child: SkeletonLine(width: 120.w, height: 18.h),
                ),
                SizedBox(height: 16.h),
                // Gender Row
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 80.w, height: 16.h),
                      SkeletonLine(width: 150.w, height: 16.h),
                    ],
                  ),
                ),
                // DOB Row
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 80.w, height: 16.h),
                      SkeletonLine(width: 150.w, height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
