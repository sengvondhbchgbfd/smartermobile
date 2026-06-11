import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class PermissionsCard extends StatelessWidget {
  final List<String> permissions;
  const PermissionsCard({super.key, required this.permissions});
  ////////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ///////////////////////////////////////////////////////////////

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceDark : Pallets.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Pallets.borderDark : Pallets.borderLight,
          width: 0.5,
        ),
      ),

      ///////////////////////////////////////////////////////////////
      ///
      ///////////////////////////////////////////////////////////////
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Permissions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
            ),
          ),
          ////////////////////////////////////////////////////////////
          const SizedBox(height: 12),
          ///////////////////////////////////////////////////////////
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissions
                .map((p) => _PermissionChip(label: p))
                .toList(),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////
class _PermissionChip extends StatelessWidget {
  final String label;
  const _PermissionChip({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Pallets.gradient2.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Pallets.gradient2,
        ),
      ),
    );
  }
}
