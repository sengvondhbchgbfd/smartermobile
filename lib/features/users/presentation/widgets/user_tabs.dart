import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:frontendmobile/features/users/presentation/screen/user_detail_screen.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_dialogs.dart';

class UserTabs extends ConsumerWidget {
  final UserState data;
  const UserTabs({super.key, required this.data});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //////////////////////////////////////////////////
    ///
    /////////////////////////////////////////////////
    if (data.users.isEmpty) {
      return const Center(child: Text("No users found"));
    }
    ////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////
    return ListView.builder(
      itemCount: data.users.length,
      itemBuilder: (_, i) {
        final user = data.users[i];
        final hasStaff = user.staff != null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            /////////////////////////////////////////
            /// AVATAR
            ////////////////////////////////////////
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              backgroundImage:
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null || user.avatarUrl!.isNotEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            ///////////////////////////////////
            /// LIST ROWS
            //////////////////////////////////
            title: Row(
              children: [
                Text(user.fullName),
                if (hasStaff) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),

                    child: Text(
                      "Staff",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            //////////////////////////////////////////////////
            /// SUBTITLE ROWS
            /// /////////////////////////////////////////////
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("@${user.username}"),
                if (hasStaff)
                  Text(
                    user.staff!.staffRole?.roleName ?? "No staff role",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),

            ///////////////////////////////////////////////
            /// ISTHREELINE
            /// //////////////////////////////////////////
            isThreeLine: hasStaff,
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  showUpdateUserDialog(context, ref, user);
                }
                if (value == 'delete') {
                  showDeleteDialog(
                    context: context,
                    tiltle: "Delete User",
                    content: "Are you want to delete ${user.fullName}?",
                    onConfirm: () => ref
                        .read(userNotifierProvider.notifier)
                        .deleteUser(user.id),
                  );
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text("Edit")),
                PopupMenuItem(value: 'delete', child: Text("Delete")),
              ],
            ),

            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            ),
          ),
        );
      },
    );
  }
}
