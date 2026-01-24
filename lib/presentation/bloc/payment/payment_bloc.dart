import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holla/repository/payment_repo.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentBloc({required PaymentRepository paymentRepository})
    : _paymentRepository = paymentRepository,
      super(PaymentInitial()) {
    on<CreatePaymentRequest>(_onCreatePaymentRequest);
    on<GetDiscounts>(_onGetDiscounts);
  }

  Future<void> _onGetDiscounts(
    GetDiscounts event,
    Emitter<PaymentState> emit,
  ) async {
    emit(GetDiscountsLoading());
    try {
      final discounts = await _paymentRepository.getDiscounts();
      emit(GetDiscountsSuccess(discounts));
    } catch (e) {
      emit(GetDiscountsFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onCreatePaymentRequest(
    CreatePaymentRequest event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentLoading());
    try {
      final payment = await _paymentRepository.createPayment(
        bookingId: event.bookingId,
        paymentMethod: event.paymentMethod,
        discountCode: event.discountCode,
      );
      emit(PaymentSuccess(payment));
    } catch (e) {
      emit(PaymentFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
