import '../models/payment_model.dart';
import '../models/discount_model.dart';

abstract class PaymentRepository {
  Future<PaymentModel> createPayment({
    required String bookingId,
    required String paymentMethod,
    String? discountCode,
  });
  Future<List<DiscountModel>> getDiscounts();
}
