import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class StatPill extends StatelessWidget {
  final String label;
  final String value;

  const StatPill({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Pallets.onAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Pallets.onAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Pallets.onAccent,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Pallets.onAccent.withValues(alpha: 0.8),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}