

import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/supplier_color.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final int maxLines;
  final SupplierColors c;
  const InfoTile({super.key, 
    required this.icon,
    required this.label,
    required this.value,
    required this.c,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value != null && value!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: c.textSecondary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: c.textTertiary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  hasValue ? value! : 'Not provided',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: hasValue ? c.textPrimary : c.textTertiary,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
