import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class HotelCardRowSkeleton extends StatelessWidget {
  const HotelCardRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Container(
          width: 340.w,
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
                height: 100,
                borderRadius: 14,
              ),
              // Content area
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonLine(width: 150.w, height: 14.h),
                        SkeletonLine(width: 50.w, height: 12.h),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Address
                    SkeletonLine(width: 200.w, height: 12.h),
                    SizedBox(height: 2.h),
                    // Price and Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonLine(width: 80.w, height: 13.h),
                        const SkeletonBox(
                          width: 80,
                          height: 28,
                          borderRadius: 8,
                        ),
                      ],
                    ),
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
