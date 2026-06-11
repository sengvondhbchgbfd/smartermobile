import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ////////////////////////////////////////////////////////////////////////////
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          ),

          //////////////////////////////////////////////////////////////////////
          const SizedBox(width: 10),
          //////////////////////////////////////////////////////////////////////
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
            ),
          ),

          //////////////////////////////////////////////////////////////////////
          const Spacer(),
          //////////////////////////////////////////////////////////////////////
          Text(
            value ?? '—',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Pallets.textPrimaryDark
                  : Pallets.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class RowDivider extends StatelessWidget {
  const RowDivider({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 0.5,
      thickness: 0.5,
      color: isDark ? Pallets.borderDark : Pallets.borderLight,
      indent: 16,
      endIndent: 16,
    );
  }
}
