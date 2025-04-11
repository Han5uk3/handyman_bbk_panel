import 'package:flutter/material.dart';

class HandySnackBar {
  static void shower({
    required BuildContext context,
    required String message,
    required bool isTrue,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: isTrue ? Colors.green : Colors.red,
              fontSize: 16.0,
            ),
          ),
          backgroundColor:
              (isTrue ? Colors.green.shade100 : Colors.red.shade100),
          duration: duration,
          action: action,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      debugPrint(
        "❌ ScaffoldMessenger not found! Ensure the context is within a Scaffold.",
      );
    }
  }

  static void show({
    required BuildContext context,
    required String message,
    required bool isTrue,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isTrue ? Colors.green : Colors.red,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: (isTrue ? Colors.green.shade100 : Colors.red.shade100),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
