import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_circle.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';

class SettingMainSkeleton extends StatelessWidget {
  const SettingMainSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                const SkeletonCircle(size: 64),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 120.w, height: 20.h),
                    SizedBox(height: 8.h),
                    SkeletonLine(width: 180.w, height: 14.h),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      children: [
                        const SkeletonBox(
                          width: 24,
                          height: 24,
                          borderRadius: 4,
                        ),
                        SizedBox(width: 16.w),
                        SkeletonLine(width: 150.w, height: 16.h),
                        const Spacer(),
                        const SkeletonBox(
                          width: 16,
                          height: 16,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
