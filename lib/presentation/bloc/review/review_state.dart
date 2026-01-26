import 'package:equatable/equatable.dart';
import '../../../models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class GetHotelReviewsSuccess extends ReviewState {
  final List<ReviewModel> reviews;
  const GetHotelReviewsSuccess(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class CreateReviewSuccess extends ReviewState {
  final String message;
  const CreateReviewSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewFailure extends ReviewState {
  final String error;
  const ReviewFailure(this.error);

  @override
  List<Object?> get props => [error];
}
