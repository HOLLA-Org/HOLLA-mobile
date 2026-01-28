import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_circle.dart';

class ReviewSkeleton extends StatelessWidget {
  const ReviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          // Rating summary skeleton
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Column(
                  children: [
                    SkeletonLine(width: 60.w, height: 48.h),
                    SizedBox(height: 8.h),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: const SkeletonBox(
                            width: 20,
                            height: 20,
                            borderRadius: 4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SkeletonLine(width: 80.w, height: 14.h),
                  ],
                ),
                SizedBox(width: 32.w),
                Expanded(
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          children: [
                            SkeletonLine(width: 12.w, height: 12.h),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: SkeletonBox(
                                width: double.infinity,
                                height: 8.h,
                                borderRadius: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Review list skeleton
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16.r),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SkeletonCircle(size: 40),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonLine(width: 100.w, height: 16.h),
                            SizedBox(height: 4.h),
                            SkeletonLine(width: 80.w, height: 12.h),
                          ],
                        ),
                        const Spacer(),
                        const SkeletonBox(
                          width: 40,
                          height: 20,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SkeletonLine(width: double.infinity, height: 14.h),
                    SizedBox(height: 8.h),
                    SkeletonLine(width: 200.w, height: 14.h),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
