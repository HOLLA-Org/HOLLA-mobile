import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class HotelCardLargeSkeleton extends StatelessWidget {
  const HotelCardLargeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 280, height: 180, borderRadius: 20),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 180.w, height: 20.h),
                  SizedBox(height: 8.h),
                  SkeletonLine(width: 120.w, height: 16.h),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 80.w, height: 20.h),
                      SkeletonLine(width: 40.w, height: 20.h),
                    ],
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

class HotelCardListSkeleton extends StatelessWidget {
  const HotelCardListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            SkeletonBox(width: 100, height: 100, borderRadius: 12),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 150.w, height: 18.h),
                  SizedBox(height: 8.h),
                  SkeletonLine(width: 100.w, height: 14.h),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SkeletonLine(width: 60.w, height: 16.h),
                      SkeletonLine(width: 40.w, height: 16.h),
                    ],
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
