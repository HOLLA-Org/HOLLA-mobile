import 'package:flutter/material.dart';
import '../../../../core/config/themes/app_colors.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final bool showDivider;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.showDivider = true,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// LABEL (LEFT)
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'CrimsonText',
                    color: AppColors.blackTypo,
                  ),
                ),
              ),

              /// VALUE + BUTTON (RIGHT)
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// TEXT
                    Expanded(
                      child: TextField(
                        controller: controller,
                        readOnly: readOnly,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'CrimsonText',
                          color:
                              readOnly
                                  ? AppColors.disableTypo
                                  : AppColors.blackTypo,
                        ),
                      ),
                    ),

                    /// BUTTON / ICON
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onSuffixTap,
                        borderRadius: BorderRadius.circular(20),

                        child: Icon(
                          suffixIcon,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.8,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.shade300,
          ),
      ],
    );
  }
}
