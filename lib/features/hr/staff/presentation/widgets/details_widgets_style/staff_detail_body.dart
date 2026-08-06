import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/action_button.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/info_card.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/rows/info_rows.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/staff_profile_card.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/rows/state_row.dart';

class StaffDetailBody extends ConsumerWidget {
  final int staffId;
  const StaffDetailBody({super.key, required this.staffId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final muted = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final faint = isDark ? Pallets.textMuted : Pallets.textSecondaryLight;

    final staff = ref.watch(staffDetailProvider(staffId)).valueOrNull;
    if (staff == null) {
      return Center(child: CircularProgressIndicator(color: Pallets.blurple));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileCard(
            staff: staff,
            surface: surface,
            border: border,
            muted: muted,
            // ── now opens the full-page avatar update screen ──
            onPickAvatar: () => context.push(
              RouteNames.staffAvatarUpdatePath(staffId),
              extra: {'name': staff.name, 'avatarUrl': staff.avatarUrl},
            ),
          ),
          const SizedBox(height: 12),
          StatsRow(staff: staff),
          const SizedBox(height: 12),

          InfoCard(
            surface: surface,
            border: border,
            muted: muted,
            title: 'Personal info',
            rows: [
              InfoRow(Icons.wc_rounded, 'Gender', staff.gender, faint: faint),
              InfoRow(
                Icons.cake_outlined,
                'Date of birth',
                staff.dateOfBirth,
                faint: faint,
              ),
              InfoRow(
                Icons.location_on_outlined,
                'Address',
                staff.address,
                faint: faint,
              ),
            ],
          ),

          const SizedBox(height: 12),
          InfoCard(
            surface: surface,
            border: border,
            muted: muted,
            title: 'Contact',
            rows: [
              InfoRow(
                Icons.mail_outline_rounded,
                'Email',
                staff.email,
                faint: faint,
                highlight: true,
              ),
              InfoRow(Icons.phone_outlined, 'Phone', staff.phone, faint: faint),
            ],
          ),

          if (staff.staffRole != null) ...[
            const SizedBox(height: 12),
            InfoCard(
              surface: surface,
              border: border,
              muted: muted,
              title: 'Role',
              rows: [
                InfoRow(
                  Icons.work_outline_rounded,
                  'Role name',
                  staff.staffRole!.roleName,
                  faint: faint,
                ),
                InfoRow(
                  Icons.manage_accounts_outlined,
                  'Is manager',
                  null,
                  faint: faint,
                  trailingBadge: staff.staffRole!.isManager ? 'Yes' : 'No',
                ),
              ],
            ),
          ],

          if (staff.createdAt != null) ...[
            const SizedBox(height: 12),
            InfoCard(
              surface: surface,
              border: border,
              muted: muted,
              title: 'Meta',
              rows: [
                InfoRow(
                  Icons.calendar_today_outlined,
                  'Joined',
                  staff.createdAt!.toLocal().toString().split(' ').first,
                  faint: faint,
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),
          ActionButtons(onDelete: () => _confirmDelete(context, ref)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
        title: Text(
          'Delete staff',
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
          ),
        ),
        content: Text(
          'Delete "$staffId"? This cannot be undone.',
          style: TextStyle(
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? Pallets.textSecondaryDark
                    : Pallets.textSecondaryLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffNotifierProvider.notifier).delete(staffId);
              Navigator.of(context).pop();
            },
            child: Text('Delete', style: TextStyle(color: Pallets.error)),
          ),
        ],
      ),
    );
  }
}
