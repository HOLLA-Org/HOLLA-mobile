import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/config/themes/app_colors.dart';

class SettingProfileHeader extends StatelessWidget {
  final String? name;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onEditTap;

  const SettingProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// AVATAR
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFFD9D9D9),
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child:
                avatarUrl == null
                    ? const Icon(
                      LucideIcons.user,
                      size: 28,
                      color: AppColors.white,
                    )
                    : null,
          ),

          const SizedBox(width: 12),

          /// NAME + EMAIL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    fontFamily: 'CrimsonText',
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        email!,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    InkWell(
                      onTap: onEditTap,
                      child: const Icon(
                        LucideIcons.edit,
                        size: 18,
                        color: Color(0xFF68E1FD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
