import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.showClose, required this.onClose});
  final bool showClose;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          if (showClose)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: onClose,
            )
          else
            const SizedBox(width: 48),
          const Expanded(
            child: Text(
              'Attendance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
