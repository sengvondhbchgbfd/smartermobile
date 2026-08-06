import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/shell_scroll_controller.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:go_router/go_router.dart';

class UserTabs extends ConsumerWidget {
  final UserState data;
  const UserTabs({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final menuBg = isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight;
    final dialogBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (data.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline_rounded, size: 48, color: textSecondary),
            const SizedBox(height: 12),
            Text(
              'No users found',
              style: TextStyle(color: textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return RefreshIndicator(
      color: Pallets.blurple,
      backgroundColor: surface,
      onRefresh: () => ref.read(userNotifierProvider.notifier).loadAll(),
      child: ListView.builder(
        controller: ShellScrollController.of(context),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: data.users.length + 1,
        itemBuilder: (_, i) {
          if (i == data.users.length) {
            return data.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }

          final user = data.users[i];
          final hasStaff = user.staff != null;

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          return GestureDetector(
            onTap: () => context.push('/users/detail', extra: user),
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
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: Pallets.blurple.withOpacity(
                    isDark ? 0.2 : 0.12,
                  ),
                  backgroundImage:
                      user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                      ? Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Pallets.blurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        )
                      : null,
                ),

                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.fullName,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.roleName != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Pallets.infoTint,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.roleName!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Pallets.blurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (hasStaff) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Pallets.successTint,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.staff!.staffRole?.roleName ?? 'No staff role',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Pallets.success
                                : const Color(0xFF27500A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      '@${user.username}',
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                isThreeLine: false,
                trailing: PopupMenuButton<String>(
                  color: menuBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: border),
                  ),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: textSecondary,
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      context.push('/users/update-user', extra: user);
                    }
                    if (value == 'delete') {
                      _confirmDelete(
                        context,
                        ref,
                        user,
                        dialogBg,
                        textPrimary,
                        textSecondary,
                      );
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Pallets.blurple,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Edit',
                            style: TextStyle(color: textPrimary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                            color: Pallets.error,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: TextStyle(color: textPrimary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    UserEntity user,
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
          'Delete User',
          style: TextStyle(color: textPrimary, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "${user.fullName}"?',
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
              ref.read(userNotifierProvider.notifier).deleteUser(user.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
