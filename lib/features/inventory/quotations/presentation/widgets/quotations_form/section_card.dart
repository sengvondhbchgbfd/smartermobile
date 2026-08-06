import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? Pallets.textPrimaryDark
                      : Pallets.textPrimaryLight,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
