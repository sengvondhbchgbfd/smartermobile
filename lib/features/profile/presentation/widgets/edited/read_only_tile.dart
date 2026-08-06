import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class ReadOnlyTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ReadOnlyTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textSecondary = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    // lock icon is intentionally muted in both modes
    final lockColor = isDark
        ? Pallets.textSecondaryDark.withOpacity(0.5)
        : Pallets.textSecondaryLight.withOpacity(0.5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textSecondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.lock_outline_rounded, size: 13, color: lockColor),
        ],
      ),
    );
  }
}