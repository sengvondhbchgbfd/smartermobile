import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:frontendmobile/features/users/presentation/screen/fillter_users_screen.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_dialogs.dart';

class RolesTab extends ConsumerWidget {
  final UserState data;
  const RolesTab({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.roles.isEmpty) {
      return const Center(child: Text("No roles found"));
    }

    return ListView.builder(
      ////////////////////////////
      ///
      ////////////////////////////
      itemCount: data.roles.length,
      itemBuilder: (_, i) {
        final role = data.roles[i];

        ///////////////////////////
        ///
        //////////////////////////

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.badge),
            title: Text(role.roleName),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => showDeleteDialog(
                context: context,
                tiltle: 'Delete Role',
                content: 'Are sure want to delete ${role.roleName}?',
                onConfirm: () =>
                    ref.read(userNotifierProvider.notifier).deleteRole(role.id),
              ),
            ),

            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FilteredUsersScreen(
                  type: "role",
                  id: role.id,
                  title: role.roleName,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
