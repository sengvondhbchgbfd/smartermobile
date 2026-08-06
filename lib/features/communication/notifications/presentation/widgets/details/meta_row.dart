import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class MetaRow extends StatelessWidget {
  const MetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ Theme-aware colors
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final primaryText = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 17, color: subText),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 13, color: subText)),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? primaryText,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 16, color: Pallets.gradient2),
            ],
          ],
        ),
      ),
    );
  }
}
