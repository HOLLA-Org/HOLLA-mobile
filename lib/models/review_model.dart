import 'user_info_model.dart';

class ReviewModel {
  final String id;
  final double rating;
  final String comment;
  final DateTime reviewDate;
  final UserInfo user;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.reviewDate,
    required this.user,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      reviewDate:
          json['review_date'] != null
              ? DateTime.parse(json['review_date'])
              : DateTime.now(),
      user: UserInfo.fromJson(json['user'] ?? {}),
    );
  }
}
