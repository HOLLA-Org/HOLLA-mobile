import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/review/review_bloc.dart';
import '../../bloc/review/review_state.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../widget/header_with_back.dart';
import '../../../models/review_model.dart';
import '../../widget/review/review_card.dart';
import '../../widget/shimmer/review_skeleton.dart';

class ReviewScreen extends StatelessWidget {
  final List<ReviewModel> reviews;
  final double rating;
  final int ratingCount;

  const ReviewScreen({
    super.key,
    required this.reviews,
    required this.rating,
    required this.ratingCount,
  });

  /// Handle back button press
  void _handleBack(BuildContext context) {
    context.pop();
  }

  /// Get star percentage
  double _getStarPercentage(List<ReviewModel> reviewList, int star) {
    if (reviewList.isEmpty) return 0;
    int count = reviewList.where((r) => r.rating.round() == star).length;
    return count / reviewList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderWithBack(
        title: "hotel_detail.reviews".tr(),
        onBack: () => _handleBack(context),
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading) {
            return const ReviewSkeleton();
          }

          final displayReviews =
              state is GetHotelReviewsSuccess ? state.reviews : reviews;

          return Column(
            children: [
              // Rating summary section
              Padding(
                padding: EdgeInsets.only(left: 16.r, right: 16.r, bottom: 16.r),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackTypo,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              color:
                                  index < rating.round()
                                      ? Colors.amber
                                      : Colors.grey[300],
                              size: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'hotel_detail.reviews_count'.tr(
                            namedArgs: {
                              'count': NumberFormat(
                                '#,###',
                              ).format(ratingCount),
                            },
                          ),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      child: Column(
                        children: List.generate(5, (index) {
                          int star = 5 - index;
                          double percent = _getStarPercentage(
                            displayReviews,
                            star,
                          );
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              children: [
                                Text(
                                  '$star',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.r),
                                    child: LinearProgressIndicator(
                                      value: percent,
                                      backgroundColor: Colors.grey[200],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.amber,
                                          ),
                                      minHeight: 8.h,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

              // Review list section
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.r),
                  itemCount: displayReviews.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    return ReviewCard(review: displayReviews[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
