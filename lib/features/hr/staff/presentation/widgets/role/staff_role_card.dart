import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import '../../../domain/entities/staff_role_entity.dart';

class StaffRoleCard extends ConsumerWidget {
  final StaffRoleEntity role;
  const StaffRoleCard({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary =
        isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final textSecondary =
        isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;

    return Container(
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
          onTap: () => context.push(RouteNames.staffRoleForm, extra: role),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoleAvatar(isManager: role.isManager),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              role.roleName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: textPrimary,
                              ),
                            ),
                          ),
                          if (role.isManager) const _ManagerBadge(),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        role.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5, color: textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Base Salary: \$${role.baseSalary.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Pallets.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _RoundIconButton(
                      icon: Icons.edit_outlined,
                      color: Pallets.blurple,
                      background: Pallets.infoTint,
                      onPressed: () =>
                          context.push(RouteNames.staffRoleForm, extra: role),
                    ),
                    const SizedBox(height: 8),
                    _RoundIconButton(
                      icon: Icons.delete_outline,
                      color: Pallets.error,
                      background: Pallets.errorTint,
                      onPressed: () => _confirmDelete(context, ref),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
        title: const Text('Delete Role'),
        content: Text('Delete "${role.roleName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffRoleNotifierProvider.notifier).delete(role.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Pallets.error)),
          ),
        ],
      ),
    );
  }
}

class _RoleAvatar extends StatelessWidget {
  final bool isManager;
  const _RoleAvatar({required this.isManager});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: isManager ? Pallets.warningTint : Pallets.infoTint,
      child: Icon(
        isManager ? Icons.manage_accounts : Icons.person,
        color: isManager ? Pallets.warning : Pallets.blurple,
      ),
    );
  }
}

class _ManagerBadge extends StatelessWidget {
  const _ManagerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Pallets.warningTint,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Manager',
        style: TextStyle(
          fontSize: 10.5,
          color: Pallets.warning,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onPressed;

  const _RoundIconButton({
    required this.icon,
    required this.color,
    required this.background,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}