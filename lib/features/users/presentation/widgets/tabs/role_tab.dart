import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/shell_scroll_controller.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:go_router/go_router.dart';

class RolesTab extends ConsumerWidget {
  final UserState data;
  const RolesTab({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dialogBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;

    if (data.roles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.badge_outlined, size: 48, color: textSecondary),
            const SizedBox(height: 12),
            Text(
              'No roles found',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: ShellScrollController.of(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: data.roles.length,
      itemBuilder: (_, i) {
        final role = data.roles[i];
        final userCount = data.users.where((u) => u.roleId == role.id).length;

        return GestureDetector(
          onTap: () => context.push(
            '/users/filtered',
            extra: {'type': 'role', 'id': role.id, 'title': role.roleName},
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Pallets.infoTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Pallets.blurple,
                  size: 20,
                ),
              ),
              title: Text(
                role.roleName,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '$userCount ${userCount == 1 ? 'user' : 'users'}',
                style: TextStyle(color: textSecondary, fontSize: 12),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Pallets.error,
                  size: 20,
                ),
                onPressed: () => _confirmDelete(
                  context,
                  ref,
                  role,
                  dialogBg,
                  textPrimary,
                  textSecondary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    role,
    Color dialogBg,
    Color textPrimary,
    Color textSecondary,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Role',
          style: TextStyle(color: textPrimary, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "${role.roleName}"?',
          style: TextStyle(color: textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text('Cancel', style: TextStyle(color: textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallets.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              ctx.pop();
              ref.read(userNotifierProvider.notifier).deleteRole(role.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
