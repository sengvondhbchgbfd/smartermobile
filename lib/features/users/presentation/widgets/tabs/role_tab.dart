import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:go_router/go_router.dart';

class RolesTab extends ConsumerWidget {
  final UserState data;
  const RolesTab({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.roles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.badge_outlined,
                size: 48, color: Pallets.textSecondaryDark),
            const SizedBox(height: 12),
            Text(
              'No roles found',
              style:
                  TextStyle(color: Pallets.textSecondaryDark, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: data.roles.length,
      itemBuilder: (_, i) {
        final role = data.roles[i];

        // count users assigned to this role
        final userCount =
            data.users.where((u) => u.roleId == role.id).length;

        return GestureDetector(
          onTap: () => context.push(
            '/users/filtered',
            extra: {
              'type': 'role',
              'id': role.id,
              'title': role.roleName,
            },
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Pallets.gradient2.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.badge_outlined,
                    color: Pallets.gradient2, size: 20),
              ),
              title: Text(
                role.roleName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '$userCount ${userCount == 1 ? 'user' : 'users'}',
                style: TextStyle(
                  color: Pallets.textSecondaryDark,
                  fontSize: 12,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.redAccent, size: 20),
                onPressed: () => _confirmDelete(context, ref, role),
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Role',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'Are you sure you want to delete "${role.roleName}"?',
          style:
              TextStyle(color: Pallets.textSecondaryDark, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text('Cancel',
                style: TextStyle(color: Pallets.textSecondaryDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              ctx.pop();
              ref
                  .read(userNotifierProvider.notifier)
                  .deleteRole(role.id);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}