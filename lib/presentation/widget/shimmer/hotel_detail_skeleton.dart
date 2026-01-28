import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class HotelDetailSkeleton extends StatelessWidget {
  const HotelDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image area
            const SkeletonBox(
              width: double.infinity,
              height: 220,
              borderRadius: 0,
            ),

            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SkeletonLine(width: 250.w, height: 28.h),
                  SizedBox(height: 12.h),
                  // Location
                  Row(
                    children: [
                      const SkeletonBox(width: 16, height: 16, borderRadius: 4),
                      SizedBox(width: 8.w),
                      SkeletonLine(width: 200.w, height: 14.h),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Services section
                  Row(
                    children: [
                      const SkeletonBox(width: 20, height: 20, borderRadius: 4),
                      SizedBox(width: 8.w),
                      SkeletonLine(width: 100.w, height: 18.h),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: List.generate(
                      4,
                      (index) => const SkeletonBox(
                        width: 80,
                        height: 36,
                        borderRadius: 8,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Policy section
                  Row(
                    children: [
                      const SkeletonBox(width: 20, height: 20, borderRadius: 4),
                      SizedBox(width: 8.w),
                      SkeletonLine(width: 120.w, height: 18.h),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  SkeletonLine(width: double.infinity, height: 14.h),
                  SizedBox(height: 8.h),
                  SkeletonLine(width: double.infinity, height: 14.h),
                  SizedBox(height: 24.h),

                  // Reviews section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 150.w, height: 18.h),
                      SkeletonLine(width: 60.w, height: 14.h),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 100.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => SizedBox(width: 16.w),
                      itemBuilder:
                          (_, __) => const SkeletonBox(
                            width: 240,
                            height: 100,
                            borderRadius: 12,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
