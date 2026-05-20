import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
class FilteredUsersScreen extends ConsumerWidget {
  final String type;
  final int id;
  final String title;
  const FilteredUsersScreen({
    super.key,
    required this.type,
    required this.id,
    required this.title,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(userNotifierProvider);
    return asyncState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
      data: (state) {
        final filtered = state.users.where((user) {
          if (type == "role") {
            return user.roleId == id;
          } else {
            return user.departmentId == id;
          }
        }).toList();

        return Scaffold(
          appBar: AppBar(title: Text("Users in $title")),
          body: filtered.isEmpty
              ? const Center(child: Text("No users found"))
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final user = filtered[i];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.fullName),
                      subtitle: Text(user.username),
                    );
                  },
                ),
        );
      },
    );
  }
}
