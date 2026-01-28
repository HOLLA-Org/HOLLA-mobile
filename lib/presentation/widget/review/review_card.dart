import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../models/review_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final double? width;

  const ReviewCard({super.key, required this.review, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage:
                    review.user.avatarUrl != null &&
                            review.user.avatarUrl!.isNotEmpty
                        ? NetworkImage(review.user.avatarUrl!)
                        : const AssetImage('assets/images/avatar/avatar.jpg'),
                backgroundColor: Colors.blue[100],
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            review.user.username,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              color:
                                  index < review.rating.round()
                                      ? Colors.amber
                                      : Colors.grey[300],
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      review.comment.isNotEmpty
                          ? review.comment
                          : 'review.default_comment'.tr(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat('dd / MM / yyyy').format(review.reviewDate),
              style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}
