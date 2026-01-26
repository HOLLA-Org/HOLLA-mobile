import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/review_repo.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(ReviewInitial()) {
    on<CreateReview>(_onCreateReview);
  }

  Future<void> _onCreateReview(
    CreateReview event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoading());
    try {
      await reviewRepository.createReview(
        bookingId: event.bookingId,
        rating: event.rating,
        comment: event.comment,
      );
    } catch (e) {
      emit(ReviewFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
