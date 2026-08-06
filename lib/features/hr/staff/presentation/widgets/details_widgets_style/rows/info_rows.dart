import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color faint;
  final bool highlight;
  final String? trailingBadge;
  const InfoRow(
    this.icon,
    this.label,
    this.value, {
    super.key,
    required this.faint,
    this.highlight = false,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: faint),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 14, color: primary)),
          ),
          if (trailingBadge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Pallets.infoTint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                trailingBadge!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Pallets.blurple,
                ),
              ),
            )
          else
            Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 13,
                color: highlight
                    ? Pallets.blurple
                    : (value != null ? primary : faint),
              ),
            ),
        ],
      ),
    );
  }
}
