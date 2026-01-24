import '../../widget/notification_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/hotel_detail_model.dart';
import '../../bloc/booking/booking_bloc.dart';
import '../../bloc/booking/booking_event.dart';
import '../../bloc/booking/booking_state.dart';
import '../../../core/config/routes/app_routes.dart';
import '../payment/payment_args.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../widget/header_with_back.dart';
import '../../widget/booking/booking_calendar.dart';
import '../../widget/booking/booking_selection_list.dart';
import '../../widget/booking/booking_summary_bottom_bar.dart';

class BookingTimeScreen extends StatefulWidget {
  final HotelDetailModel hotel;
  const BookingTimeScreen({super.key, required this.hotel});

  @override
  State<BookingTimeScreen> createState() => _BookingTimeScreenState();
}

class _BookingTimeScreenState extends State<BookingTimeScreen> {
  bool isHourly = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTimeRange? _selectedRange;

  String _selectedTime = "00:00";
  int _selectedDuration = 2;

  final List<String> _times = [
    "00:00",
    "00:30",
    "01:00",
    "01:30",
    "02:00",
    "03:00",
    "03:30",
    "04:00",
    "04:30",
    "05:00",
    "05:30",
    "06:00",
    "06:30",
    "07:00",
    "07:30",
    "08:00",
    "08:30",
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
  ];

  final List<int> _durations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(
      _focusedDay.year,
      _focusedDay.month,
      _focusedDay.day,
    );
  }

  /// Handle day selection on the calendar
  void _onDaySelected(DateTime date) {
    setState(() {
      if (isHourly) {
        _selectedDay = date;
      } else {
        if (_selectedRange == null ||
            (_selectedRange!.start != _selectedRange!.end)) {
          _selectedRange = DateTimeRange(start: date, end: date);
        } else {
          if (date.isBefore(_selectedRange!.start)) {
            _selectedRange = DateTimeRange(
              start: date,
              end: _selectedRange!.start,
            );
          } else {
            _selectedRange = DateTimeRange(
              start: _selectedRange!.start,
              end: date,
            );
          }
        }
      }
    });
  }

  /// Navigate to previous month
  void _onPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  /// Navigate to next month
  void _onNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  /// Switch between hourly and daily booking type
  void _onSwitchType(bool hourly) {
    setState(() => isHourly = hourly);
  }

  /// Handle check-in time selection
  void _onTimeSelected(String val) {
    setState(() => _selectedTime = val);
  }

  /// Handle usage duration selection
  void _onDurationSelected(int val) {
    setState(() => _selectedDuration = val);
  }

  /// Handle back button press
  void _handleBack() {
    context.pop();
  }

  /// Handle "Apply" button press
  void _onApply() {
    final dates = _getBookingDates();
    if (dates == null) return;

    context.read<BookingBloc>().add(
      CreateBooking(
        hotelId: widget.hotel.id,
        checkIn: dates['checkIn'],
        checkOut: dates['checkOut'],
        bookingType: isHourly ? 'per_hour' : 'per_day',
      ),
    );
  }

  /// Logic helper to calculate check-in and check-out dates
  Map<String, DateTime>? _getBookingDates() {
    DateTime? checkIn;
    DateTime? checkOut;

    if (isHourly) {
      if (_selectedDay == null) return null;
      final timeParts = _selectedTime.split(":");
      checkIn = DateTime.utc(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
      checkOut = checkIn.add(Duration(hours: _selectedDuration));
    } else {
      if (_selectedRange == null) return null;
      // Use DateTime.utc to keep it exactly at midnight UTC
      checkIn = DateTime.utc(
        _selectedRange!.start.year,
        _selectedRange!.start.month,
        _selectedRange!.start.day,
        0,
        0,
      );
      checkOut = DateTime.utc(
        _selectedRange!.end.year,
        _selectedRange!.end.month,
        _selectedRange!.end.day,
        0,
        0,
      );
    }

    return {'checkIn': checkIn, 'checkOut': checkOut};
  }

  void _navigateToPayment(String bookingId) {
    context.push(
      AppRoutes.payment,
      extra: PaymentArgs(
        bookingId: bookingId,
        hotel: widget.hotel,
        isHourly: isHourly,
        selectedDay: _selectedDay,
        selectedRange: _selectedRange,
        time: _selectedTime,
        duration: _selectedDuration,
      ),
    );
  }

  /// Show error dialog
  void _showError(BuildContext context, String message) {
    notificationDialog(
      context: context,
      title: 'Có lỗi xảy ra',
      message: message,
      isError: true,
    );
  }

  /// Get formatted check-in date/time string for display
  String get _checkInStr {
    if (isHourly) {
      if (_selectedDay == null) return "";
      return "$_selectedTime, ${DateFormat('dd/MM').format(_selectedDay!)}";
    } else {
      if (_selectedRange == null) return "";
      return "12:00, ${DateFormat('dd/MM').format(_selectedRange!.start)}";
    }
  }

  /// Get formatted check-out date/time string for display
  String get _checkOutStr {
    if (isHourly) {
      if (_selectedDay == null) return "";
      final durationParts = _selectedTime.split(":");
      final checkInTime = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
        int.parse(durationParts[0]),
        int.parse(durationParts[1]),
      );
      final checkOutTime = checkInTime.add(Duration(hours: _selectedDuration));
      return "${DateFormat('HH:mm').format(checkOutTime)}, ${DateFormat('dd/MM').format(checkOutTime)}";
    } else {
      if (_selectedRange == null) return "";
      return "12:00, ${DateFormat('dd/MM').format(_selectedRange!.end)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is CreateBookingSuccess) {
          _navigateToPayment(state.bookingId);
        } else if (state is BookingFailure) {
          _showError(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: HeaderWithBack(title: "Đặt lịch", onBack: _handleBack),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _onSwitchType(true),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Theo giờ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isHourly ? AppColors.primary : Colors.grey,
                        ),
                      ),
                      if (isHourly)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: 60,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: () => _onSwitchType(false),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Theo ngày",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !isHourly ? AppColors.primary : Colors.grey,
                        ),
                      ),
                      if (!isHourly)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: 70,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingCalendar(
                      month: _focusedDay,
                      isHourly: isHourly,
                      selectedDay: _selectedDay,
                      selectedRange: _selectedRange,
                      showChevron: isHourly,
                      onDaySelected: _onDaySelected,
                      onPreviousMonth: _onPreviousMonth,
                      onNextMonth: _onNextMonth,
                    ),
                    if (isHourly) ...[
                      BookingSelectionList<String>(
                        title: "Giờ nhận phòng",
                        items: _times,
                        selectedItem: _selectedTime,
                        onSelected: _onTimeSelected,
                        labelBuilder: (item) => item,
                      ),
                      BookingSelectionList<int>(
                        title: "Số giờ sử dụng",
                        items: _durations,
                        selectedItem: _selectedDuration,
                        onSelected: _onDurationSelected,
                        labelBuilder: (item) => "$item giờ",
                      ),
                    ],
                    if (!isHourly) ...[
                      BookingCalendar(
                        month: DateTime(
                          _focusedDay.year,
                          _focusedDay.month + 1,
                        ),
                        isHourly: isHourly,
                        selectedDay: _selectedDay,
                        selectedRange: _selectedRange,
                        showChevron: false,
                        onDaySelected: _onDaySelected,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            BookingSummaryBottomBar(
              checkInLabel: "Nhận phòng",
              checkInValue: _checkInStr,
              checkOutLabel: "Trả phòng",
              checkOutValue: _checkOutStr,
              buttonText: "Áp dụng",
              onButtonPressed: _onApply,
            ),
          ],
        ),
      ),
    );
  }
}
