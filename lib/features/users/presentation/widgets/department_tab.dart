import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:frontendmobile/features/users/presentation/screen/fillter_users_screen.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_dialogs.dart';

class DepartmentTab extends ConsumerWidget {
  final UserState data;
  const DepartmentTab({super.key, required this.data});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.departments.isEmpty) {
      return const Center(child: Text("No department found"));
    }
    return ListView.builder(
      itemCount: data.departments.length,
      itemBuilder: (_, i) {
        final dept = data.departments[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.business),
            title: Text(dept.departmentName),
            subtitle: dept.managerId != null
                ? Text("Manager ID: ${dept.managerId}")
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => showDeleteDialog(
                context: context,
                tiltle: "Delete Department",
                content: "Are you sure to delete ${dept.departmentName}?",
                onConfirm: () => ref
                    .read(userNotifierProvider.notifier)
                    .deleteDepartment(dept.departmentId),
              ),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FilteredUsersScreen(
                  type: "department",
                  id: dept.departmentId,
                  title: dept.departmentName,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
