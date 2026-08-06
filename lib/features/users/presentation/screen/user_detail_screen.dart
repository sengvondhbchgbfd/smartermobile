import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/info_file.dart';
import 'package:frontendmobile/features/users/presentation/widgets/section_card.dart';
import 'package:go_router/go_router.dart';

class UserDetailScreen extends ConsumerWidget {
  final UserEntity user;
  const UserDetailScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final iconBg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.05);
    final liveUser =
        ref
            .watch(userNotifierProvider)
            .valueOrNull
            ?.users
            .where((u) => u.id == user.id)
            .firstOrNull ??
        user;
    final staff = liveUser.staff;
    final hasAvatar =
        liveUser.avatarUrl != null && liveUser.avatarUrl!.isNotEmpty;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(
              Icons.chevron_left_rounded,
              color: textPrimary,
              size: 22,
            ),
          ),
        ),
        title: Text(
          'User Profile',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ////////////////////////////////////////////////////////////////////
            // ── Avatar (tap to view full screen) ──
            ////////////////////////////////////////////////////////////////////
            GestureDetector(
              onTap: hasAvatar
                  ? () => _viewPhoto(context, liveUser.avatarUrl!)
                  : null,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Pallets.blurple.withOpacity(
                      isDark ? 0.2 : 0.12,
                    ),
                    backgroundImage: hasAvatar
                        ? NetworkImage(liveUser.avatarUrl!)
                        : null,
                    child: !hasAvatar
                        ? Text(
                            liveUser.fullName.isNotEmpty
                                ? liveUser.fullName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Pallets.blurple,
                            ),
                          )
                        : null,
                  ),
                  if (hasAvatar)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Pallets.blurple,
                          border: Border.all(color: surface, width: 2),
                        ),
                        child: const Icon(
                          Icons.zoom_in_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              liveUser.fullName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '@${liveUser.username}',
              style: TextStyle(fontSize: 14, color: textSecondary),
            ),

            if (staff != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Pallets.successTint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Staff · ${staff.staffRole?.roleName ?? 'No Role'}',
                  style: TextStyle(
                    color: isDark ? Pallets.success : const Color(0xFF27500A),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),
            SectionCard(
              title: 'Account Info',
              icon: Icons.manage_accounts_outlined,
              cardBg: cardBg,
              border: border,
              textPrimary: textPrimary,
              children: [
                InfoTile(
                  icon: Icons.badge_outlined,
                  title: 'Role',
                  value: liveUser.roleName ?? 'N/A',
                  textSecondary: textSecondary,
                  textPrimary: textPrimary,
                ),
                InfoTile(
                  icon: Icons.business_outlined,
                  title: 'Department',
                  value: liveUser.departmentName ?? 'N/A',
                  textSecondary: textSecondary,
                  textPrimary: textPrimary,
                ),
                InfoTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Status',
                  value: liveUser.status,
                  valueColor: liveUser.status == 'active'
                      ? Pallets.success
                      : Pallets.error,
                  textSecondary: textSecondary,
                  textPrimary: textPrimary,
                ),
                InfoTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Created At',
                  value: _formatDate(liveUser.createdAt),
                  textSecondary: textSecondary,
                  textPrimary: textPrimary,
                ),
                InfoTile(
                  icon: Icons.update_outlined,
                  title: 'Updated At',
                  value: _formatDate(liveUser.updatedAt),
                  textSecondary: textSecondary,
                  textPrimary: textPrimary,
                ),
              ],
            ),

            if (staff != null) ...[
              const SizedBox(height: 16),
              SectionCard(
                title: 'Staff Profile',
                icon: Icons.badge_outlined,
                cardBg: cardBg,
                border: border,
                textPrimary: textPrimary,
                children: [
                  InfoTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Name',
                    value: staff.name,
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  InfoTile(
                    icon: Icons.work_outline_rounded,
                    title: 'Staff Role',
                    value: staff.staffRole?.roleName ?? 'N/A',
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  InfoTile(
                    icon: Icons.wc_outlined,
                    title: 'Gender',
                    value: staff.gender ?? 'N/A',
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  InfoTile(
                    icon: Icons.cake_outlined,
                    title: 'Date of Birth',
                    value: staff.dateOfBirth ?? 'N/A',
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  InfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: staff.phone ?? 'N/A',
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  InfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: staff.email ?? 'N/A',
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  InfoTile(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: staff.address ?? 'N/A',
                    textSecondary: textSecondary,
                    textPrimary: textPrimary,
                  ),
                  if (staff.age != null)
                    InfoTile(
                      icon: Icons.numbers_outlined,
                      title: 'Age',
                      value: '${staff.age}',
                      textSecondary: textSecondary,
                      textPrimary: textPrimary,
                    ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: textSecondary),
                    const SizedBox(width: 12),
                    Text(
                      'No staff profile assigned',
                      style: TextStyle(color: textSecondary, fontSize: 13),
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _viewPhoto(BuildContext context, String avatarUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(child: InteractiveViewer(child: Image.network(avatarUrl))),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
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
