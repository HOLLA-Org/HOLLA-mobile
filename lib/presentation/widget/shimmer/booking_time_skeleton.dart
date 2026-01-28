import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:holla/presentation/widget/shimmer/shimmer_loading.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_box.dart';
import 'package:holla/presentation/widget/shimmer/skeleton_line.dart';

class BookingTimeSkeleton extends StatelessWidget {
  const BookingTimeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonLine(width: 80.w, height: 20.h),
              SizedBox(width: 60.w),
              SkeletonLine(width: 80.w, height: 20.h),
            ],
          ),
          SizedBox(height: 16.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const SkeletonBox(
                      width: double.infinity,
                      height: 300,
                      borderRadius: 12,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Selection Lists
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: 150.w, height: 20.h),
                        SizedBox(height: 12.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              5,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: const SkeletonBox(
                                  width: 80,
                                  height: 40,
                                  borderRadius: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SkeletonLine(width: 150.w, height: 20.h),
                        SizedBox(height: 12.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              5,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: const SkeletonBox(
                                  width: 60,
                                  height: 40,
                                  borderRadius: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SkeletonLine(width: 100.w, height: 14.h),
                      SizedBox(height: 4.h),
                      SkeletonLine(width: 120.w, height: 16.h),
                    ],
                  ),
                ),
                const SkeletonBox(width: 120, height: 48, borderRadius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
