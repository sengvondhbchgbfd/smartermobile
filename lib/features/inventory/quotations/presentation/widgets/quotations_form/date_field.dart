import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value),
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }
}