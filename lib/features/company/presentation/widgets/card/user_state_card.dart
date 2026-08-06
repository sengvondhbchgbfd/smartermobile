import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/stacked_avatars.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/users_bottom_sheet.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ratio = maxUsers > 0 ? currentUsers / maxUsers : 0.0;
    final remaining = maxUsers - currentUsers;
    final isFull = remaining <= 0;
    final isWarning = ratio >= 0.9 && !isFull;
    final displayed = users.take(4).toList();
    final extra = users.length > 4 ? users.length - 4 : 0;

    final card = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final iconBg = Pallets.blurple.withOpacity(isDark ? 0.18 : 0.10);

    final barColor = isFull
        ? Pallets.error
        : isWarning
        ? Pallets.warning
        : Pallets.blurple;

    final screen = MediaQuery.of(context).size.width;
    final isCompact = screen < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 14 : 16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.people_alt_outlined,
                  color: Pallets.blurple,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Team Members',
                style: TextStyle(
                  color: t2,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              _CapacityBadge(
                isFull: isFull,
                isWarning: isWarning,
                remaining: remaining,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Count + label row ────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$currentUsers',
                style: TextStyle(
                  color: t1,
                  fontSize: isCompact ? 28 : 34,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  letterSpacing: -1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 6),
                child: Text(
                  '/ $maxUsers seats',
                  style: TextStyle(
                    color: t2,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Spacer(),
              // Usage % pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(ratio * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: barColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Progress bar ─────────────────────────────────────────────
          _AnimatedBar(ratio: ratio, color: barColor, isDark: isDark),
          const SizedBox(height: 16),

          // ── Divider ──────────────────────────────────────────────────
          Divider(
            height: 1,
            color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
          ),
          const SizedBox(height: 14),

          // ── Avatars row ──────────────────────────────────────────────
          if (displayed.isNotEmpty)
            GestureDetector(
              onTap: () => _showUsersSheet(context, isDark),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  StackedAvatars(users: displayed, extra: extra),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          users.length == 1
                              ? users.first.name
                              : '${users.length} team members',
                          style: TextStyle(
                            color: t1,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (users.length > 1)
                          Text(
                            'Tap to view all',
                            style: TextStyle(color: t2, fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Pallets.blurple.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Pallets.blurple.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'View all',
                          style: TextStyle(
                            color: Pallets.blurple,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Pallets.blurple,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Pallets.surfaceElevated
                        : Pallets.backgroundLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: border),
                  ),
                  child: Icon(Icons.person_add_outlined, color: t2, size: 15),
                ),
                const SizedBox(width: 10),
                Text(
                  'No members yet',
                  style: TextStyle(color: t2, fontSize: 12),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showUsersSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => UsersBottomSheet(users: users, maxUsers: maxUsers),
    );
  }
}

// ── Capacity badge ─────────────────────────────────────────────────────────
class _CapacityBadge extends StatelessWidget {
  final bool isFull;
  final bool isWarning;
  final int remaining;
  const _CapacityBadge({
    required this.isFull,
    required this.isWarning,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isFull
        ? Pallets.error
        : isWarning
        ? Pallets.warning
        : Pallets.success;
    final String label = isFull
        ? '⚠ Full'
        : isWarning
        ? '$remaining left'
        : '$remaining left';
    final IconData icon = isFull
        ? Icons.block_rounded
        : isWarning
        ? Icons.warning_amber_rounded
        : Icons.check_circle_outline_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated progress bar ──────────────────────────────────────────────────
class _AnimatedBar extends StatelessWidget {
  final double ratio;
  final Color color;
  final bool isDark;
  const _AnimatedBar({
    required this.ratio,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // Track
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Fill
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: ratio.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) => FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.7), color],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
