import 'package:flutter/material.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key, required this.isCheckIn});
  final bool isCheckIn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isCheckIn ? '✅ Checked In!' : '✅ Checked Out!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isCheckIn
                ? 'Your attendance has been recorded.'
                : 'Your check-out has been recorded.',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 32),
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Closing…',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
