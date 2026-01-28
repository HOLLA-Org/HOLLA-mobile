import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/hotel_card_row_skeleton.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';

class BookingHistorySkeleton extends StatelessWidget {
  const BookingHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Skeleton
          Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 16.h),
            child: SkeletonLine(width: 180.w, height: 28.h),
          ),

          // Tabs Skeleton
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Expanded(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 36,
                    borderRadius: 20,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 36,
                    borderRadius: 20,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 36,
                    borderRadius: 20,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // List items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              itemCount: 5,
              itemBuilder: (context, index) => const HotelCardRowSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
