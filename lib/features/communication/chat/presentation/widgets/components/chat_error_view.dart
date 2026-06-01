import 'package:flutter/material.dart';

class ChatErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const ChatErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: Color(0xFF8a9bb0),
          ),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF8a9bb0), fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
              style: TextStyle(color: Color(0xFF5caeff)),
            ),
          ),
        ],
      ),
    ),
  );
}
