import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:go_router/go_router.dart';

class UserTabs extends ConsumerWidget {
  final UserState data;
  const UserTabs({super.key, required this.data});
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline_rounded,
              size: 48,
              color: Pallets.textSecondaryDark,
            ),
            const SizedBox(height: 12),
            Text(
              'No users found',
              style: TextStyle(color: Pallets.textSecondaryDark, fontSize: 14),
            ),
          ],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: data.users.length,
      itemBuilder: (_, i) {
        final user = data.users[i];
        final hasStaff = user.staff != null;

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////

        return GestureDetector(
          onTap: () => context.push('/users/detail', extra: user),

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),

              //══════════════════════════════════════
              // Avatar
              //══════════════════════════════════════
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: Pallets.gradient2.withOpacity(0.2),
                backgroundImage:
                    user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                    ? Text(
                        user.fullName.isNotEmpty
                            ? user.fullName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Pallets.gradient2,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      )
                    : null,
              ),

              //══════════════════════════════════════
              // Title row
              //══════════════════════════════════════
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // ← show role badge for ALL users, not just hasStaff
                  if (user.roleName != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.roleName!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],

                  // ← separate green badge only when hasStaff
                  if (hasStaff) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.staff!.staffRole?.roleName ?? 'No staff role',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              //══════════════════════════════════════
              // Subtitle
              //══════════════════════════════════════
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    '@${user.username}',
                    style: TextStyle(
                      color: Pallets.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              isThreeLine: false,

              //══════════════════════════════════════
              // Actions menu
              //══════════════════════════════════════
              trailing: PopupMenuButton<String>(
                color: const Color(0xFF2C2C3E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: Pallets.textSecondaryDark,
                  size: 20,
                ),

                ////////////////////////////////////////////////////////////
                ///  Update
                ///////////////////////////////////////////////////////////
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/users/update-user', extra: user);
                  }
                  if (value == 'delete') {
                    _confirmDelete(context, ref, user);
                  }
                },
                ////////////////////////////////////////////////////////////
                ///
                ///////////////////////////////////////////////////////////
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 16,
                          color: Pallets.gradient2,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Edit',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  ////////////////////////////////////////////////////////////
                  ///
                  ///////////////////////////////////////////////////////////
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline_rounded,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],

                ////////////////////////////////////////////////////////////
                ///
                ///////////////////////////////////////////////////////////
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, UserEntity user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete User',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          'Are you sure you want to delete "${user.fullName}"?',
          style: TextStyle(color: Pallets.textSecondaryDark, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Pallets.textSecondaryDark),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
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
