import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_image_widgets/staff_avatar.dart';

class StaffCard extends ConsumerWidget {
  final StaffEntity staff;
  const StaffCard({super.key, required this.staff});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Dismissible(
      key: ValueKey(staff.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context, ref),
      onDismissed: (_) =>
          ref.read(staffNotifierProvider.notifier).delete(staff.id!),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Pallets.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1),
        ),
        child: Material(
          color: Pallets.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push(RouteNames.staffDetailPath(staff.id!)),
            onLongPress: () => context.push(RouteNames.staffForm, extra: staff),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  StaffAvatar(
                    name: staff.name,
                    avatarUrl: staff.avatarUrl,
                    radius: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                staff.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            if (staff.staffRole != null)
                              _RoleTag(name: staff.staffRole!.roleName),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _IconText(
                          icon: Icons.mail_outline_rounded,
                          text: staff.email,
                          color: textSecondary,
                        ),
                        _IconText(
                          icon: Icons.call_outlined,
                          text: staff.phone,
                          color: textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: textSecondary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
        title: const Text('Delete Staff'),
        content: Text('Delete "${staff.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Pallets.error)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Color color;
  const _IconText({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleTag extends StatelessWidget {
  final String name;
  const _RoleTag({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Pallets.infoTint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Pallets.blurple,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
        ),
      ),
    );
  }
}
