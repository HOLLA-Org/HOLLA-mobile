abstract class ReviewRepository {
  Future<void> createReview({
    required String bookingId,
    required double rating,
    required String comment,
  });
}
