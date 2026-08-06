
import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent, textSecondary, border, card;
  final VoidCallback onTap;

  const FilterChips({super.key, 
    required this.label,
    required this.selected,
    required this.accent,
    required this.textSecondary,
    required this.border,
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(0.1) : card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accent.withOpacity(0.4) : border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? accent : textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
