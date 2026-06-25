import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color textSecondary;
  final Color surface;
  final Color border;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.textSecondary,
    required this.surface,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Pallets.gradient2 : surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Pallets.gradient2 : border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : textSecondary,
          ),
        ),
      ),
    );
  }
}