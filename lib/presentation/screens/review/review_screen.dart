import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../widget/header_with_back.dart';
import '../../../models/review_model.dart';
import '../../widget/review/review_card.dart';

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
  double _getStarPercentage(int star) {
    if (reviews.isEmpty) return 0;
    int count = reviews.where((r) => r.rating.round() == star).length;
    return count / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderWithBack(
        title: "hotel_detail.reviews".tr(),
        onBack: () => _handleBack(context),
      ),
      body: Column(
        children: [
          // Rating summary section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
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
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'hotel_detail.reviews_count'.tr(
                        namedArgs: {
                          'count': NumberFormat('#,###').format(ratingCount),
                        },
                      ),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      int star = 5 - index;
                      double percent = _getStarPercentage(star);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Text(
                              '$star',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: percent,
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.amber,
                                      ),
                                  minHeight: 8,
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
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                return ReviewCard(review: reviews[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
