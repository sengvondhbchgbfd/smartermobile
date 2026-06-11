import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:go_router/go_router.dart';

class UserDetailScreen extends ConsumerWidget {
  final UserEntity user;
  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    // ✅ Watch live state — reflects deletions/updates immediately
    ////////////////////////////////////////////////////////////////////////////
    final liveUser =
        ref
            .watch(userNotifierProvider)
            .valueOrNull
            ?.users
            .where((u) => u.id == user.id)
            .firstOrNull ??
        user;
    final staff = liveUser.staff;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //══════════════════════════════════════
            // Avatar
            //══════════════════════════════════════
            CircleAvatar(
              radius: 50,
              backgroundColor: Pallets.gradient2.withOpacity(0.2),
              backgroundImage:
                  liveUser.avatarUrl != null && liveUser.avatarUrl!.isNotEmpty
                  ? NetworkImage(liveUser.avatarUrl!)
                  : null,
              child: liveUser.avatarUrl == null || liveUser.avatarUrl!.isEmpty
                  ? Text(
                      liveUser.fullName.isNotEmpty
                          ? liveUser.fullName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Pallets.gradient2,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            Text(
              liveUser.fullName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@${liveUser.username}',
              style: TextStyle(fontSize: 14, color: Pallets.textSecondaryDark),
            ),

            //══════════════════════════════════════
            // Staff badge
            //══════════════════════════════════════
            if (staff != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.greenAccent.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Staff · ${staff.staffRole?.roleName ?? 'No Role'}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),

            //══════════════════════════════════════
            // Account Info card
            //══════════════════════════════════════
            _SectionCard(
              title: 'Account Info',
              icon: Icons.manage_accounts_outlined,
              children: [
                _InfoTile(
                  icon: Icons.badge_outlined,
                  title: 'Role',
                  value: liveUser.roleName ?? 'N/A',
                ),
                _InfoTile(
                  icon: Icons.business_outlined,
                  title: 'Department',
                  value: liveUser.departmentName ?? 'N/A',
                ),
                _InfoTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Status',
                  value: liveUser.status,
                  valueColor: liveUser.status == 'active'
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
                _InfoTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Created At',
                  value: _formatDate(liveUser.createdAt),
                ),
                _InfoTile(
                  icon: Icons.update_outlined,
                  title: 'Updated At',
                  value: _formatDate(liveUser.updatedAt),
                ),
              ],
            ),

            //══════════════════════════════════════
            // Staff profile card
            //══════════════════════════════════════
            if (staff != null) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Staff Profile',
                icon: Icons.badge_outlined,
                children: [
                  _InfoTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Name',
                    value: staff.name,
                  ),
                  _InfoTile(
                    icon: Icons.work_outline_rounded,
                    title: 'Staff Role',
                    value: staff.staffRole?.roleName ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.wc_outlined,
                    title: 'Gender',
                    value: staff.gender ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.cake_outlined,
                    title: 'Date of Birth',
                    value: staff.dateOfBirth ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: staff.phone ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: staff.email ?? 'N/A',
                  ),
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: staff.address ?? 'N/A',
                  ),
                  if (staff.age != null)
                    _InfoTile(
                      icon: Icons.numbers_outlined,
                      title: 'Age',
                      value: '${staff.age}',
                    ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Pallets.textSecondaryDark),
                    const SizedBox(width: 12),
                    Text(
                      'No staff profile assigned',
                      style: TextStyle(
                        color: Pallets.textSecondaryDark,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ── Section Card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {

  
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.08)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Pallets.gradient2),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...children
            .expand((w) => [w, Divider(color: Colors.white.withOpacity(0.06))])
            .toList()
          ..removeLast(), // remove trailing divider
      ],
    ),
  );
}

// ── Info Tile ─────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Pallets.textSecondaryDark),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Pallets.textSecondaryDark,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
