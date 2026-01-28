import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/hotel_card_large_skeleton.dart';
import 'package:holla/presentation/widget/shimmer/hotel_card_row_skeleton.dart';
import 'package:holla/presentation/widget/shimmer/hotel_card_small_skeleton.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            SkeletonLine(width: 150.w, height: 16.h),
            SizedBox(height: 8.h),
            // Title
            SkeletonLine(width: 200.w, height: 24.h),
            SizedBox(height: 16.h),
            // Search Bar
            SkeletonBox(width: double.infinity, height: 40, borderRadius: 24),
            SizedBox(height: 24.h),

            // Popular Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 100.w, height: 20.h),
                SkeletonLine(width: 60.w, height: 16.h),
              ],
            ),
            SizedBox(height: 12.h),
            // Popular Hotels Horizontal List
            SizedBox(
              height: 225.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (_, __) => const HotelCardLargeSkeleton(),
              ),
            ),

            SizedBox(height: 24.h),
            // Top Rated Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 120.w, height: 20.h),
                SkeletonLine(width: 60.w, height: 16.h),
              ],
            ),
            SizedBox(height: 12.h),
            // Top Rated Horizontal List
            SizedBox(
              height: 165.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (_, __) => const HotelCardSmallSkeleton(),
              ),
            ),
            SizedBox(height: 24.h),
            // Recommended Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLine(width: 140.w, height: 20.h),
                SkeletonLine(width: 60.w, height: 16.h),
              ],
            ),
            SizedBox(height: 12.h),
            // Recommended Horizontal List
            SizedBox(
              height: 195.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (_, __) => const HotelCardRowSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
