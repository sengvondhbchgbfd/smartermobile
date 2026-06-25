import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

InputDecoration inputDecoration(
  BuildContext context, {
  required String hint,
  bool locked = false,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight,
    ),
    filled: true,
    fillColor: isDark
        ? locked
              ? const Color(0xFF2B2D31)
              : Pallets.surfaceDark
        : locked
        ? const Color(0xFFEEEEEE)
        : Pallets.surfaceLight,
    suffixIcon: locked
        ? Icon(
            Icons.lock_outline,
            size: 16,
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          )
        : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: isDark ? Pallets.borderDark : Pallets.borderLight,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Pallets.gradient2, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Pallets.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Pallets.error, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight,
        letterSpacing: 0.3,
      ),
    );
  }
}
