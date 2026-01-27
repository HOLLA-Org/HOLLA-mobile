import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../bloc/review/review_bloc.dart';
import '../../bloc/review/review_event.dart';
import '../../bloc/review/review_state.dart';
import '../../widget/notification_dialog.dart';
import '../../widget/confirm_button.dart';
import '../../widget/header_with_back.dart';

class WriteReviewScreen extends StatefulWidget {
  final String bookingId;
  const WriteReviewScreen({super.key, required this.bookingId});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Submit review
  void _submitReview() {
    context.read<ReviewBloc>().add(
      CreateReview(
        bookingId: widget.bookingId,
        rating: _rating,
        comment: _commentController.text.trim(),
      ),
    );
  }

  /// Handle back button
  void _handleBack(BuildContext context) {
    context.pop();
  }

  /// Show success notification and navigate home
  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('review.success_message'.tr()),
        backgroundColor: AppColors.primary,
      ),
    );
    context.pop();
  }

  /// Show error notification
  void _showError(String message) {
    notificationDialog(
      context: context,
      title: 'review.failure_message'.tr(),
      message: message,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReviewBloc, ReviewState>(
      listener: (context, state) {
        if (state is CreateReviewSuccess) {
          _showSuccess(context);
        } else if (state is ReviewFailure) {
          _showError(state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: HeaderWithBack(
          title: 'review.title'.tr(),
          onBack: () => _handleBack(context),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text title review
                Text(
                  'review.question'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'review.subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
                SizedBox(height: 24.h),
                // Row rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      iconSize: 32.sp,
                      onPressed: () {
                        setState(() {
                          _rating = index + 1.0;
                        });
                      },
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color:
                            index < _rating ? Colors.amber : AppColors.disable,
                      ),
                    );
                  }),
                ),
                SizedBox(height: 12.h),
                Text(
                  '$_rating/5.0',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(height: 36.h),

                // Text title comment
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'review.comment_title'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _commentController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(fontSize: 15.sp, color: AppColors.blackTypo),
                  decoration: InputDecoration(
                    hintText: 'review.comment_hint'.tr(),
                    hintStyle: TextStyle(
                      color: AppColors.bodyTypo.withOpacity(0.5),
                      fontSize: 15.sp,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16.r),
                  ),
                ),

                const Spacer(),

                // Button submit review
                Padding(
                  padding: EdgeInsets.only(bottom: 60.h),
                  child: Center(
                    child: ConfirmButton(
                      text: 'review.submit_button'.tr(),
                      onPressed: _submitReview,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
