import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class DateTile extends StatelessWidget {
  final DateTime? dob;
  final VoidCallback onTap;

  const DateTile({super.key, required this.dob, required this.onTap});

  String get _label {
    if (dob == null) return 'Date of Birth';
    return '${dob!.day.toString().padLeft(2, '0')}/'
        '${dob!.month.toString().padLeft(2, '0')}/'
        '${dob!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, size: 18, color: textSecondary),
            const SizedBox(width: 10),
            Text(
              _label,
              style: TextStyle(
                fontSize: 14,
                color: dob == null ? textSecondary : textPrimary,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary),
          ],
        ),
      ),
    );
  }
}
