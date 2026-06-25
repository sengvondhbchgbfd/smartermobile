import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final Color textSecondary;
  const SectionLabel({
    super.key,
    required this.label,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
    ),
  );
}
