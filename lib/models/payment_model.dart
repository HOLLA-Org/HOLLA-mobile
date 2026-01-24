class PaymentModel {
  final String id;
  final String userId;
  final String bookingId;
  final String paymentMethod;
  final String? discountId;
  final int amount;
  final String status;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.paymentMethod,
    this.discountId,
    required this.amount,
    required this.status,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      discountId: json['discount_id'],
      amount: json['amount'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}
