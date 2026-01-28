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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Container(
          width: 200.w,
          margin: EdgeInsets.only(right: 16.w),
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
                height: 120,
                borderRadius: 14,
              ),
              // Content area
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    SkeletonLine(width: 150.w, height: 14.h),
                    SizedBox(height: 2.h),
                    // Rating
                    SkeletonLine(width: 80.w, height: 12.h),
                    SizedBox(height: 2.h),
                    // Address
                    SkeletonLine(width: 120.w, height: 12.h),
                    SizedBox(height: 2.h),
                    // Price
                    SkeletonLine(width: 100.w, height: 13.h),
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
