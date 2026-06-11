import 'package:flutter/material.dart';

class ChatErrorBanner extends StatelessWidget {
  final String error;
  const ChatErrorBanner({super.key, required this.error});

  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFFa32d2d).withOpacity(0.85),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            error,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}
