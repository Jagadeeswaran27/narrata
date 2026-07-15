import 'package:flutter/material.dart';

class CustomToast {
  static void showSuccess(BuildContext context, String message) {
    _showToast(context, message, isError: false);
  }

  static void showError(BuildContext context, String message) {
    _showToast(context, message, isError: true);
  }

  static void _showToast(BuildContext context, String message, {required bool isError}) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = isError ? colorScheme.errorContainer : Colors.green.shade100;
    final fgColor = isError ? colorScheme.onErrorContainer : Colors.green.shade800;
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: fgColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: fgColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
