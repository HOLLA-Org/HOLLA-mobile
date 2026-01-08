import 'package:flutter/material.dart';

class SettingSectionTitle extends StatelessWidget {
  final String title;

  const SettingSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          fontFamily: 'CrimsonText',
        ),
      ),
    );
  }
}
