import 'package:flutter/material.dart';
import 'action_button.dart';

class BookingSummaryBottomBar extends StatelessWidget {
  final String checkInLabel;
  final String checkInValue;
  final String checkOutLabel;
  final String checkOutValue;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const BookingSummaryBottomBar({
    super.key,
    required this.checkInLabel,
    required this.checkInValue,
    required this.checkOutLabel,
    required this.checkOutValue,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildSummaryItem(checkInLabel, checkInValue),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("-", style: TextStyle(color: Colors.grey)),
                  ),
                  _buildSummaryItem(checkOutLabel, checkOutValue),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ActionButton(text: buttonText, onTap: onButtonPressed),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }
}
