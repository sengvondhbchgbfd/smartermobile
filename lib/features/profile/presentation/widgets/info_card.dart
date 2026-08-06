import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';

class InfoCard extends StatelessWidget {
  final ProfileEntity profile;
  const InfoCard({super.key, required this.profile});
  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSub = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    ///////////////////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////////////////////

    return Column(
      children: [
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        _InfoTile(
          label: 'Member Since',
          surface: surface,
          border: border,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range,
                size: 16,
                color: textPrimary.withOpacity(0.5),
              ),
              const SizedBox(width: 6),
              Text(
                profile.memberSince ?? 'N/A',
                style: TextStyle(fontSize: 14, color: textSub),
              ),
            ],
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        _InfoTile(
          label: 'Department',
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          trailingText: profile.department ?? '—',
        ),
        const SizedBox(height: 8),
        _InfoTile(
          label: 'Role',
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          trailingText: profile.role,
        ),
        const SizedBox(height: 8),
        _InfoTile(
          label: 'Note (only visible to you)',
          surface: surface,
          border: border,
          textPrimary: textPrimary,
          icon: Icons.note_add_outlined,
          trailingText: '_',
        ),
      ],
    );
  }
}
////////////////////////////////////////////////////////////////////////////////
// ─────────────────────────────────────────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class _InfoTile extends StatelessWidget {
  final String label;
  final String? trailingText;
  final Widget? trailing;
  final IconData? icon;
  final Color? textPrimary;
  final Color surface;
  final Color border;

  const _InfoTile({
    required this.label,
    required this.surface,
    required this.border,
    this.trailingText,
    this.trailing,
    this.icon,
    this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 0.5),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          trailing ??
              Row(
                children: [
                  if (trailingText != null && trailingText!.isNotEmpty)
                    Text(
                      trailingText!,
                      style: TextStyle(fontSize: 14, color: textPrimary),
                    ),
                  if (icon != null) ...[
                    const SizedBox(width: 6),
                    Icon(icon, size: 18, color: textPrimary?.withOpacity(0.5)),
                  ] else ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: textPrimary?.withOpacity(0.5),
                      size: 18,
                    ),
                  ],
                ],
              ),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}
