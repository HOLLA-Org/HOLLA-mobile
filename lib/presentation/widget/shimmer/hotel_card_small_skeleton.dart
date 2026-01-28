import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class HotelCardSmallSkeleton extends StatelessWidget {
  const HotelCardSmallSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Container(
          width: 145.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              const SkeletonBox(
                width: double.infinity,
                height: 80,
                borderRadius: 14,
              ),
              // Content area
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    SkeletonLine(width: 100.w, height: 12.h),
                    SizedBox(height: 4.h),
                    // Rating
                    SkeletonLine(width: 60.w, height: 11.h),
                    SizedBox(height: 4.h),
                    // Price
                    SkeletonLine(width: 80.w, height: 11.h),
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
