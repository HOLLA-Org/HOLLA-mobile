import 'package:flutter/material.dart';

Future<void> notificationDialog({
  required BuildContext context,
  required String title,
  required String message,
  bool isError = false,
  VoidCallback? onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlayfairDisplay',
            color: isError ? Colors.red : const Color(0xFF008080),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: 'CrimsonText',
              color: Colors.grey[600],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Đồng ý',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
