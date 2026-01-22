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
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;
              return GestureDetector(
                onTap: () => onSelected(item),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.hover,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        labelBuilder(item),
                        style: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black54,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
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
