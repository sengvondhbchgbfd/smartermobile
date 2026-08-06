import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/shell_scroll_controller.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:go_router/go_router.dart';

class DepartmentTab extends ConsumerWidget {
  final UserState data;
  const DepartmentTab({super.key, required this.data});

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

    if (data.departments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business_outlined, size: 48, color: textSecondary),
            const SizedBox(height: 12),
            Text(
              'No departments found',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: ShellScrollController.of(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: data.departments.length,
      itemBuilder: (_, i) {
        final dept = data.departments[i];
        final manager = dept.managerId != null
            ? data.users.where((u) => u.id == dept.managerId).firstOrNull
            : null;

        return GestureDetector(
          onTap: () => context.push(
            '/users/filtered',
            extra: {
              'type': 'department',
              'id': dept.departmentId,
              'title': dept.departmentName,
            },
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
                  Icons.business_outlined,
                  color: Pallets.blurple,
                  size: 20,
                ),
              ),
              title: Text(
                dept.departmentName,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                manager != null
                    ? 'Manager: ${manager.fullName}'
                    : 'No manager assigned',
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
                  dept,
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
    dept,
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
          'Delete Department',
          style: TextStyle(color: textPrimary, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "${dept.departmentName}"?',
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
              ref
                  .read(userNotifierProvider.notifier)
                  .deleteDepartment(dept.departmentId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
