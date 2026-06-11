import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  InputDecoration _decoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InputDecoration(
      labelText: label,

      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: 20,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
            )
          : null,

      filled: true,
      fillColor: isDark ? Pallets.surfaceDark : Pallets.surfaceLight,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Pallets.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Pallets.error, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
<<<<<<< HEAD
      initialValue: value,
=======
      value: value,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      items: items,
      onChanged: onChanged,
      validator: validator,
      dropdownColor: isDark
          ? Pallets.surfaceDark
          : Pallets.surfaceLight,
      decoration: _decoration(context),
      style: TextStyle(
        color: isDark
            ? Pallets.textPrimaryDark
            : Pallets.textPrimaryLight,
        fontSize: 14,
      ),
    );
  }
}