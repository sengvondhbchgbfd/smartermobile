import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class GenderDropdown extends StatelessWidget {
  final String? value;
  final List<String> genders;
  final ValueChanged<String?> onChanged;

  const GenderDropdown({
    super.key,
    required this.value,
    required this.genders,
    required this.onChanged,
  });

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            'Gender',
            style: TextStyle(color: textSecondary, fontSize: 13),
          ),
          dropdownColor: fillColor,
          iconEnabledColor: textSecondary,
          isExpanded: true,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(
                'Prefer not to say',
                style: TextStyle(color: textSecondary, fontSize: 14),
              ),
            ),
            ...genders.map(
              (g) => DropdownMenuItem(
                value: g,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      g[0].toUpperCase() + g.substring(1),
                      style: TextStyle(color: textPrimary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
