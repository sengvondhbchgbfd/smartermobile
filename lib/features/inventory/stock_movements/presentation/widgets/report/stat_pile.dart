import 'package:flutter/material.dart';









class StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color card;
  final Color border;
  final Color sub;
  final Color textPrimary;






  const StatPill({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.card,
    required this.border,
    required this.sub,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 14, color: accent),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: sub,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
