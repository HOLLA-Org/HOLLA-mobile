import 'package:equatable/equatable.dart';
import 'package:holla/models/payment_model.dart';
import 'package:holla/models/discount_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentModel payment;

  const PaymentSuccess(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class GetDiscountsLoading extends PaymentState {}

class GetDiscountsSuccess extends PaymentState {
  final List<DiscountModel> discounts;

  const GetDiscountsSuccess(this.discounts);

  @override
  List<Object?> get props => [discounts];
}

class GetDiscountsFailure extends PaymentState {
  final String error;

  const GetDiscountsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
