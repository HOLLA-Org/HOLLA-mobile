import 'package:flutter/material.dart';

import '../../core/config/themes/app_colors.dart';

class EmptyList extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const EmptyList({
    super.key,
    this.title = 'No Nurses Found for Your Search',
    this.subtitle = 'Please try again later',
    this.imagePath = 'assets/images/search/not_found_nurse.png',
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
          SizedBox(height: 16),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.headingTypo,
            ),
          ),
          SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.blackTypo,
            ),
          ),

          SizedBox(height: 60),
        ],
      ),
    );
  }
}
