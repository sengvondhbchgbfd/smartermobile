import 'package:flutter/material.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';

class InfoCard extends StatelessWidget {
  final ProfileEntity profile;
  const InfoCard({super.key, required this.profile});

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        _InfoTile(
          label: 'Member Since',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.date_range, size: 16, color: Color(0xFF5865F2)),
              const SizedBox(width: 6),
              Text(
                profile.memberSince ?? 'N/A',
                style: const TextStyle(fontSize: 14, color: Color(0xFFB5BAC1)),
              ),
            ],
          ),
        ),

        ////////////////////////////////////////////////////////////////////////
        const SizedBox(height: 8),
        ////////////////////////////////////////////////////////////////////////
        _InfoTile(label: 'Department', trailingText: profile.department ?? '—'),
        const SizedBox(height: 8),
        _InfoTile(label: 'Role', trailingText: profile.role),
        const SizedBox(height: 8),
        _InfoTile(
          label: 'Note (only visible to you)',
          icon: Icons.note_add_outlined,
          trailingText: '_',
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _InfoTile extends StatelessWidget {
  final String label;
  final String? trailingText;
  final Widget? trailing;
  final IconData? icon;

  const _InfoTile({
    required this.label,
    this.trailingText,
    this.trailing,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing ??
              Row(
                children: [
                  if (trailingText != null && trailingText!.isNotEmpty)
                    Text(
                      trailingText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB5BAC1),
                      ),
                    ),
                  if (icon != null) ...[
                    const SizedBox(width: 6),
                    Icon(icon, size: 18, color: const Color(0xFF80848E)),
                  ] else ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFF80848E),
                    ),
                  ],
                ],
              ),
        ],
      ),
    );
  }
}
