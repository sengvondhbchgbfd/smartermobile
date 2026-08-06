import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final Color textSecondary, accent;
  final VoidCallback onRetry;
  const ErrorState({
    super.key,
    required this.textSecondary,
    required this.accent,
    required this.onRetry,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, color: textSecondary, size: 48),
          const SizedBox(height: 12),
          Text(
            'Leave not found',
            style: TextStyle(color: textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(backgroundColor: accent),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
