import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';

class UserListTile extends StatelessWidget {
  final StaffPreview user;
  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final avatarBg = isDark ? Pallets.surfaceElevated : Pallets.borderLight;

    final isActive = user.status == 'active';
    final dotColor = isActive ? Pallets.success : Pallets.inactive;
    final badgeBg = dotColor.withOpacity(0.12);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────
          CircleAvatar(
            radius: 22,
            backgroundColor: avatarBg,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: t1,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),

          // ── Name + role ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: t1,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.roleName.isEmpty ? '—' : user.roleName,
                  style: TextStyle(color: t2, fontSize: 12),
                ),
              ],
            ),
          ),

          // ── Status badge ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: dotColor.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  user.status,
                  style: TextStyle(
                    color: dotColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
