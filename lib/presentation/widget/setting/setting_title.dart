import 'package:flutter/material.dart';
import 'package:holla/core/config/themes/app_colors.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 4,
              top: 24,
              bottom: 4,
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: Colors.black87),
                const SizedBox(width: 12),

                /// TITLE
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontFamily: 'CrimsonText',
                    ),
                  ),
                ),

                /// TRAILING
                if (trailing != null) ...[
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTypo,
                      fontFamily: 'CrimsonText',
                    ),
                    child: trailing!,
                  ),
                ],
              ],
            ),
          ),

          /// DIVIDER
          if (showDivider)
            Divider(
              height: 1,
              thickness: 0.8,
              indent: 50,
              color: Colors.grey.shade300,
            ),
        ],
      ),
    );
  }
}
