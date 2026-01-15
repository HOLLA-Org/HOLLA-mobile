import 'package:flutter/material.dart';
import '../../../core/config/themes/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionTitle({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onViewAll,
          child: const Text(
            'Xem tất cả',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
