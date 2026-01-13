import 'package:flutter/material.dart';
import 'package:holla/core/config/themes/app_colors.dart';

class NotificationActionSheet extends StatelessWidget {
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onDeleteAll;
  final bool showMarkAllRead;
  final bool showDeleteAll;

  const NotificationActionSheet({
    super.key,
    this.onMarkAllRead,
    this.onDeleteAll,
    this.showMarkAllRead = false,
    this.showDeleteAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Divider
            Container(
              width: 36,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Mark all as read
            if (showMarkAllRead)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                title: Text(
                  'Đánh dấu tất cả đã xem',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackTypo,
                  ),
                ),
                onTap: onMarkAllRead,
              ),

            // Delete all
            if (showDeleteAll)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 24),

                title: Text(
                  'Xóa tất cả',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackTypo,
                  ),
                ),
                onTap: onDeleteAll,
              ),
          ],
        ),
      ),
    );
  }
}
