import 'package:flutter/material.dart';

class ReasonCard extends StatelessWidget {
  final String reason;
  final Color card, border, textPrimary;

  const ReasonCard({
    super.key,
    required this.reason,
    required this.card,
    required this.border,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Text(
        reason,
        style: TextStyle(
          color: textPrimary.withOpacity(0.87),
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }
}
