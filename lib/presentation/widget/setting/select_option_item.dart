import 'package:flutter/material.dart';
import 'package:holla/core/config/themes/app_colors.dart';

class SelectOptionItem extends StatelessWidget {
  final String label;
  final String? value;
  final String? groupValue;
  final ValueChanged<String> onChanged;

  const SelectOptionItem({
    super.key,
    required this.label,
    this.value,
    this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String actualValue = value ?? label;
    final bool isSelected = actualValue == (groupValue ?? '');

    return GestureDetector(
      onTap: () => onChanged(actualValue),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.blur.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackTypo,
                ),
                softWrap: true,
              ),
            ),

            SizedBox(width: 12),

            // Check box
            Center(
              child: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color:
                    isSelected
                        ? AppColors.primary.withOpacity(0.6)
                        : AppColors.disable,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
