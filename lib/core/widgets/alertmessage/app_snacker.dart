import 'package:flutter/material.dart';

enum SnackType { success, error, warning, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final config = _config(type);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(config.icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: config.color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: duration,
        ),
      );
  }

  static ({Color color, IconData icon}) _config(SnackType type) =>
      switch (type) {
        SnackType.success => (
          color: const Color(0xFF2E7D32),
          icon: Icons.check_circle_outline,
        ),
        SnackType.error => (
          color: const Color(0xFFC62828),
          icon: Icons.error_outline,
        ),
        SnackType.warning => (
          color: const Color(0xFFE65100),
          icon: Icons.warning_amber_outlined,
        ),
        SnackType.info => (
          color: const Color(0xFF1565C0),
          icon: Icons.info_outline,
        ),
      };
}
