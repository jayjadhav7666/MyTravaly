import 'package:flutter/material.dart';

class CustomWidgets {
  static showCustomSnackBar(
      {required String text,
      required BuildContext context,
      required Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
