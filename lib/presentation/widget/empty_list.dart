import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/themes/app_colors.dart';

class EmptyList extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const EmptyList({
    super.key,
    this.title = 'home.no_hotels',
    this.subtitle = 'home.no_hotels_message',
    this.imagePath = 'assets/images/search/not_found_hotel.png',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          SizedBox(
            width: 160,
            height: 160,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            title.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.blackTypo,
            ),
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
