import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  /// Optional overrides — all default to the previous hardcoded look,
  /// so existing call sites don't need to change.
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.only(bottom: 14),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final iconBg = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;

    final content = Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? Pallets.borderDark : Pallets.borderLight,
              ),
            ),
            child: Icon(icon, color: iconColor ?? Pallets.blurple, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: t2, fontSize: 11)),
                const SizedBox(height: 1),
                Text(
                  value ?? '—',
                  style: TextStyle(
                    color: t1,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: content,
    );
  }
}
