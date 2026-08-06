import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final Color textSecondary;
  const SectionLabel({super.key, required this.label, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}