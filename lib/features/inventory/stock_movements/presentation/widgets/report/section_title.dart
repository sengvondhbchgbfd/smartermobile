import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color sub;
  const SectionTitle({super.key, 
    required this.icon,
    required this.text,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: sub),
        const SizedBox(width: 6),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: sub,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}