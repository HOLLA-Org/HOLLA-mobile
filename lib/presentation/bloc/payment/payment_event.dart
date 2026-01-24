import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreatePaymentRequest extends PaymentEvent {
  final String bookingId;
  final String paymentMethod;
  final String? discountCode;

  const CreatePaymentRequest({
    required this.bookingId,
    required this.paymentMethod,
    this.discountCode,
  });

  @override
  List<Object?> get props => [bookingId, paymentMethod, discountCode];
}

class GetDiscounts extends PaymentEvent {}
