import 'package:flutter/material.dart';


class AttendanceErrorMessage {
  AttendanceErrorMessage._();

  static void show(
    BuildContext context, {
    required String message,
    required VoidCallback onDismiss,
    VoidCallback? onRetry, 
  }) {
    if (!context.mounted) return;

    if (_isCritical(message)) {
      _showDialog(context, message: message, onDismiss: onDismiss, onRetry: onRetry);
    } else {
      _showSnackBar(context, message: message, onDismiss: onDismiss);
    }
  }

  // ── Type detection ───────────────────────────────────────────────────────

  static bool _isCritical(String message) {
    final lower = message.toLowerCase();
    return lower.contains('session') ||
        lower.contains('expired') ||
        lower.contains('unauthorized') ||
        lower.contains('login') ||
        lower.contains('forbidden') ||
        lower.contains('network') ||
        lower.contains('timeout') ||
        lower.contains('connection');
  }

  // ── Dialog (critical errors) ─────────────────────────────────────────────

  static void _showDialog(
    BuildContext context, {
    required String message,
    required VoidCallback onDismiss,
    VoidCallback? onRetry,
  }) {
    final isAuth = message.toLowerCase().contains('session') ||
        message.toLowerCase().contains('expired') ||
        message.toLowerCase().contains('unauthorized') ||
        message.toLowerCase().contains('login') ||
        message.toLowerCase().contains('forbidden');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AttendanceErrorDialog(
        message: message,
        isAuth: isAuth,
        onDismiss: onDismiss,
        onRetry: onRetry,
      ),
    );
  }

  // ── SnackBar (non-critical errors) ───────────────────────────────────────

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required VoidCallback onDismiss,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFB00020),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: onDismiss,
          ),
        ),
      );
  }
}

// ── Dialog widget ─────────────────────────────────────────────────────────────

class _AttendanceErrorDialog extends StatelessWidget {
  const _AttendanceErrorDialog({
    required this.message,
    required this.isAuth,
    required this.onDismiss,
    this.onRetry,
  });

  final String message;
  final bool isAuth;
  final VoidCallback onDismiss;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isAuth ? Colors.red : Colors.orange).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAuth ? Icons.lock_outline : Icons.wifi_off_rounded,
              color: isAuth ? Colors.red : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isAuth ? 'Session Error' : 'Connection Error',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ),
      actions: [
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry!();
            },
            child: const Text('Retry'),
          ),
        FilledButton(
          onPressed: () {
            onDismiss();
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(
            backgroundColor: isAuth ? Colors.red : Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}