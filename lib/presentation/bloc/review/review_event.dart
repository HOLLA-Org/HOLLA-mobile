import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchHotelReviews extends ReviewEvent {
  final String hotelId;

  const FetchHotelReviews(this.hotelId);

  @override
  List<Object?> get props => [hotelId];
}

class CreateReview extends ReviewEvent {
  final String bookingId;
  final double rating;
  final String comment;

  const CreateReview({
    required this.bookingId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [bookingId, rating, comment];
}
