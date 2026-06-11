import 'package:flutter/material.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/stacked_avatars.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/users_bottom_sheet.dart';
import '../../../../../core/themes/app_pallets.dart';

// ── Model ──────────────────────────────────────────────────────────────────
class StaffPreview {
  final int userId;
  final String name;
  final String roleName;
  final String? avatarUrl;
  final String status;
  const StaffPreview({
    required this.userId,
    required this.name,
    required this.roleName,
    this.avatarUrl,
    this.status = 'active',
  });
}

// ── Card ───────────────────────────────────────────────────────────────────
class UsersStatCard extends StatelessWidget {
  final int currentUsers;
  final int maxUsers;
  final List<StaffPreview> users;
  const UsersStatCard({
    super.key,
    required this.currentUsers,
    required this.maxUsers,
    this.users = const [],
  });

  @override
  Widget build(BuildContext context) {
    final ratio = maxUsers > 0 ? currentUsers / maxUsers : 0.0;
    final remaining = maxUsers - currentUsers;
    final displayed = users.take(3).toList();
    final extra = users.length > 3 ? users.length - 3 : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Pallets.backgroundDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ////////////////////////////////////////////////////////////////
          // ── Label ──
          ////////////////////////////////////////////////////////////////
          Text(
            'USERS',
            style: TextStyle(
              color: Pallets.textSecondaryDark,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),

          ////////////////////////////////////////////////////////////////
          // ── Count ──
          ////////////////////////////////////////////////////////////////
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$currentUsers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' / $maxUsers',
                  style: TextStyle(
                    color: Pallets.textSecondaryDark,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$remaining slots remaining',
            style: TextStyle(color: Pallets.textSecondaryDark, fontSize: 11),
          ),

          ////////////////////////////////////////////////////////////////
          // ── Stacked Avatars (tappable) ──
          ////////////////////////////////////////////////////////////////
          if (displayed.isNotEmpty) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showUsersSheet(context),
              child: Row(
                children: [
                  StackedAvatars(users: displayed, extra: extra),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Pallets.textSecondaryDark,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),

          ////////////////////////////////////////////////////////////////
          // ── Progress ──
          ////////////////////////////////////////////////////////////////
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentUsers active',
                style: TextStyle(
                  color: Pallets.textSecondaryDark,
                  fontSize: 10,
                ),
              ),
              Text(
                '$maxUsers max',
                style: TextStyle(
                  color: Pallets.textSecondaryDark,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation(Pallets.gradient2),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////////
  // ── Bottom Sheet ──
  ////////////////////////////////////////////////////////////////
  void _showUsersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Pallets.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => UsersBottomSheet(users: users, maxUsers: maxUsers),
    );
  }
}
