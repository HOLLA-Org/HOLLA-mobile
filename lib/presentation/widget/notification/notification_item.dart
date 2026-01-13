import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/config/themes/app_colors.dart';

class NotificationItem extends StatelessWidget {
  final String id;
  final String title;
  final String? content;
  final DateTime createdAt;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NotificationItem({
    super.key,
    required this.id,
    required this.title,
    required this.createdAt,
    this.content,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F4F3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mail,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTypo,
                              height: 1.2,
                              fontFamily: 'CrimsonText',
                            ),
                          ),
                        ),

                        // More
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: PopupMenuButton(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.more_vert,
                                size: 16,
                                color: AppColors.disableTypo,
                              ),
                              itemBuilder:
                                  (_) => const [
                                    PopupMenuItem<String>(
                                      height: 4,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      value: 'delete',
                                      child: Center(
                                        child: Text(
                                          'Xoá',
                                          style: TextStyle(
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                              onSelected: (value) {
                                if (value == 'delete') {
                                  onDelete!();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Content
                    Text(
                      content ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.disableTypo,
                        fontFamily: 'CrimsonText',
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.disableTypo,
                          fontFamily: 'CrimsonText',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
