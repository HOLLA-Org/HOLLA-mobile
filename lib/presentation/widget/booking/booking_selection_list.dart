import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../core/config/themes/app_colors.dart';

class BookingSelectionList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T selectedItem;
  final Function(T) onSelected;
  final String Function(T) labelBuilder;

  const BookingSelectionList({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 8.h),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 32.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;
              return GestureDetector(
                onTap: () => onSelected(item),
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.hover,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        labelBuilder(item),
                        style: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black54,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
