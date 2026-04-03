import 'package:flutter/material.dart';

class ToastService {
  void showSuccess(BuildContext context, String message, {int duration = 2}) {
    _showTopToast(
      context: context,
      message: message,
      backgroundColor: Colors.black,
      icon: Icons.check_circle,
      durationSeconds: duration,
    );
  }

  void showError(BuildContext context, String message, {int duration = 2}) {
    _showTopToast(
      context: context,
      message: message,
      backgroundColor: Colors.red[700]!,
      icon: Icons.error,
      durationSeconds: duration,
    );
  }

  void _showTopToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    int durationSeconds = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: durationSeconds),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 130,
          left: 20,
          right: 20,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}