import 'package:flutter/material.dart';

import '../../../../../core/themes/app_pallets.dart';

class SalaryRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const SalaryRow({super.key, 
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          ),
        ),
        Text(
          '\$${value.abs().toStringAsFixed(2)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
