import 'hotel_model.dart';

enum BookingStatus { pending, active, completed, cancelled }

class BookingModel {
  final String id;
  final HotelModel hotel;
  final String userId;
  final BookingStatus status;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int totalPrice;
  final int paidAmount;
  final bool? isReviewed;

  BookingModel({
    required this.id,
    required this.hotel,
    required this.userId,
    required this.status,
    this.checkIn,
    this.checkOut,
    required this.totalPrice,
    required this.paidAmount,
    this.isReviewed,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final hasNestedHotel = json['hotel_id'] != null && json['hotel_id'] is Map;

    return BookingModel(
      id: json['bookingId'] ?? json['_id'] ?? '',
      hotel: HotelModel.fromJson(hasNestedHotel ? json['hotel_id'] : json),
      userId: json['user_id'] ?? '',
      status: _mapStatus(json['bookingStatus'] ?? json['status'] ?? 'pending'),
      checkIn:
          (json['check_in'] ?? json['checkIn']) != null
              ? DateTime.parse(json['check_in'] ?? json['checkIn'])
              : null,
      checkOut:
          (json['check_out'] ?? json['checkOut']) != null
              ? DateTime.parse(json['check_out'] ?? json['checkOut'])
              : null,
      totalPrice: json['price'] ?? json['total_price'] ?? 0,
      paidAmount: json['paid_amount'] ?? 0,
      isReviewed: json['isReviewed'] ?? false,
    );
  }

  static BookingStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'active':
        return BookingStatus.active;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}
