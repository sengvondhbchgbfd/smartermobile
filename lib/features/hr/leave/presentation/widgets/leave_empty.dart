import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Color textSecondary, accent;
  const EmptyState({super.key, required this.textSecondary, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_rounded, color: textSecondary, size: 48),
          const SizedBox(height: 12),
          Text(
            'No leave requests',
            style: TextStyle(color: textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}