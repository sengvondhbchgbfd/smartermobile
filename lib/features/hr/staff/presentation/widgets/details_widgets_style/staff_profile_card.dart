import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class ProfileCard extends StatelessWidget {
  final StaffEntity staff;
  final Color surface;
  final Color border;
  final Color muted;
  final VoidCallback onPickAvatar;
  const ProfileCard({
    super.key,
    required this.staff,
    required this.surface,
    required this.border,
    required this.muted,
    required this.onPickAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: onPickAvatar, // ← whole avatar now tappable too
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: Pallets.blurple.withOpacity(
                    isDark ? 0.2 : 0.12,
                  ),
                  backgroundImage: staff.avatarUrl != null
                      ? NetworkImage(staff.avatarUrl!)
                      : null,
                  child: staff.avatarUrl == null
                      ? Text(
                          staff.name.isNotEmpty
                              ? staff.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Pallets.blurple,
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: onPickAvatar,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallets.blurple,
                      border: Border.all(color: surface, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            staff.name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Pallets.textPrimaryDark
                  : Pallets.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            staff.staffRole?.roleName ?? 'No role assigned',
            style: TextStyle(fontSize: 13, color: muted),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Pallets.successTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 3, backgroundColor: Pallets.success),
                const SizedBox(width: 6),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Pallets.success : const Color(0xFF27500A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
