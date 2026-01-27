import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/config/themes/app_colors.dart';

class BookingCalendar extends StatelessWidget {
  final DateTime month;
  final bool isHourly;
  final DateTime? selectedDay;
  final DateTimeRange? selectedRange;
  final bool showChevron;
  final Function(DateTime) onDaySelected;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;

  const BookingCalendar({
    super.key,
    required this.month,
    required this.isHourly,
    this.selectedDay,
    this.selectedRange,
    this.showChevron = false,
    required this.onDaySelected,
    this.onPreviousMonth,
    this.onNextMonth,
  });

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  bool _isInRange(DateTime date) {
    if (selectedRange == null) return false;
    return (date.isAfter(selectedRange!.start) ||
            _isSameDay(date, selectedRange!.start)) &&
        (date.isBefore(selectedRange!.end) ||
            _isSameDay(date, selectedRange!.end));
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    // Get localized weekdays
    final locale = context.locale.toString();
    final date = DateTime(2024, 1, 1); // A Monday
    final weekdays = List.generate(7, (index) {
      final d = date.add(Duration(days: index));
      return DateFormat.E(locale).format(d).toUpperCase();
    });

    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.hover,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackTypo.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  final formattedDate = DateFormat.yMMMM(locale).format(month);
                  final capitalizedDate =
                      formattedDate.isNotEmpty
                          ? '${formattedDate[0].toUpperCase()}${formattedDate.substring(1)}'
                          : formattedDate;
                  return Text(
                    capitalizedDate,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              if (showChevron)
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 24.sp),
                      onPressed: onPreviousMonth,
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 24.sp),
                      onPressed: onNextMonth,
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                weekdays
                    .map(
                      (d) => Text(
                        d,
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      ),
                    )
                    .toList(),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 12.w,
            ),
            itemCount: daysInMonth + (firstWeekday - 1),
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) return const SizedBox();
              final day = index - (firstWeekday - 2);
              final date = DateTime(month.year, month.month, day);

              final isSelected =
                  isHourly
                      ? (selectedDay != null && _isSameDay(selectedDay!, date))
                      : _isInRange(date);

              return GestureDetector(
                onTap: () => onDaySelected(date),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primary.withOpacity(0.2) : null,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 36.w,
                      height: 36.h,
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                isSelected ? AppColors.primary : Colors.black,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
