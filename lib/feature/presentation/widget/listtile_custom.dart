import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const ListTileCustom({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.black),
          title: Text(
            title,
            style: TextStyle(color: textColor ?? Colors.black),
          ),
          trailing:
              trailingText != null
                  ? Text(
                    trailingText!,
                    style: TextStyle(color: textColor ?? Colors.black54),
                  )
                  : null,
          onTap: onTap,
        ),
        const Divider(
          height: 1,
          thickness: 1.0,
          indent: 16,
          endIndent: 16,
          color: Colors.grey,
        ),
      ],
    );
  }
}
