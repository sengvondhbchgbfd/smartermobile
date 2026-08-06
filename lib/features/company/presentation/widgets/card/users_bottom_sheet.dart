import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_list_tile.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';

class UsersBottomSheet extends StatelessWidget {
  final List<StaffPreview> users;
  final int maxUsers;
  const UsersBottomSheet({
    super.key,
    required this.users,
    required this.maxUsers,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final handle = isDark ? Pallets.borderDark : Pallets.borderLight;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          // ── Handle ──────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: handle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Team Members',
                  style: TextStyle(
                    color: t1,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Pallets.surfaceElevated
                          : Pallets.backgroundLight,
                      border: Border.all(color: border),
                    ),
                    child: Icon(Icons.close_rounded, color: t2, size: 17),
                  ),
                ),
              ],
            ),
          ),

          // ── Summary row ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Icon(Icons.people_outline, color: Pallets.blurple, size: 17),
                  const SizedBox(width: 8),
                  Text(
                    'Showing ${users.length} of $maxUsers members',
                    style: TextStyle(color: t2, fontSize: 13),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Pallets.blurple.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${users.length}/${maxUsers}',
                      style: const TextStyle(
                        color: Pallets.blurple,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── User list ────────────────────────────────────────────
          Expanded(
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: users.length,
              separatorBuilder: (_, __) => Divider(
                color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
                height: 1,
              ),
              itemBuilder: (_, i) => UserListTile(user: users[i]),
            ),
          ),
        ],
      ),
    );
  }
}
