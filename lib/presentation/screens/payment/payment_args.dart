import 'package:flutter/material.dart';
import 'package:holla/models/hotel_detail_model.dart';

class PaymentArgs {
  final String bookingId;
  final HotelDetailModel hotel;
  final bool isHourly;
  final DateTime? selectedDay;
  final DateTimeRange? selectedRange;
  final String? time;
  final int? duration;

  PaymentArgs({
    required this.bookingId,
    required this.hotel,
    required this.isHourly,
    this.selectedDay,
    this.selectedRange,
    this.time,
    this.duration,
  });
}
