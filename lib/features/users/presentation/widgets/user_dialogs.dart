import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/update_user_params.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';

////////////////////////////////////////////////
/// DELETE USERS
void showDeleteDialog({
  required BuildContext context,
  required String tiltle,
  required String content,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(tiltle),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}

/////////////////////////////////////////////
/// CREATE USER DIALOG
/////////////////////////////////////////////
void showCreateUserDialog(
  BuildContext context,
  WidgetRef ref,
  UserState? state,
) {
  final username = TextEditingController();
  final fullname = TextEditingController();
  final password = TextEditingController();
  int? selectedRoleId;
  int? selectedDepartmentId;
  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Create User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: username,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              //////////////////////////////////////////
              const SizedBox(height: 8),

              /////////////////////////////////////////
              TextField(
                controller: fullname,
                decoration: InputDecoration(labelText: "Full Name"),
              ),

              //////////////////////////////////////////
              const SizedBox(height: 8),
              /////////////////////////////////////////
              TextField(
                controller: password,
                decoration: InputDecoration(labelText: "Password"),
              ),
              //////////////////////////////////////////
              const SizedBox(height: 8),
              /////////////////////////////////////////
              DropdownButtonFormField<int>(
                value: selectedRoleId,
                decoration: const InputDecoration(labelText: "Role"),
                items: (state?.roles ?? [])
                    .map(
                      (r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.roleName),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedRoleId = val),
              ),

              //////////////////////////////////////////
              const SizedBox(height: 8),
              /////////////////////////////////////////
              DropdownButtonFormField<int>(
                value: selectedDepartmentId,
                decoration: const InputDecoration(labelText: "Department"),
                items: (state?.departments ?? [])
                    .map(
                      (d) => DropdownMenuItem(
                        value: d.departmentId,
                        child: Text(d.departmentName),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedDepartmentId = val),
              ),
            ],
          ),
        ),

        ////////////////////////////////////////
        /// ACTIONS
        ////////////////////////////////////////
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (username.text.trim().isEmpty ||
                  fullname.text.trim().isEmpty ||
                  password.text.trim().isEmpty ||
                  selectedRoleId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fil all required fields"),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              await ref
                  .read(userNotifierProvider.notifier)
                  .createUser(
                    RegisterUserParams(
                      username: username.text.trim(),
                      password: password.text.trim(),
                      fullName: fullname.text.trim(),
                      roleId: selectedRoleId!,
                      departmentId: selectedDepartmentId,
                    ),
                  );
            },
            child: const Text("Create"),
          ),
        ],
      ),
    ),
  );
}

///////////////////////////////////////////////////////////////////////
///  UPDATE USER DIALOG
//////////////////////////////////////////////////////////////////////

void showUpdateUserDialog(
  BuildContext context,
  WidgetRef ref,
  UserEntity user,
) {
  final username = TextEditingController(text: user.username);
  final fullname = TextEditingController(text: user.fullName);
  int? selectedRoleId = user.roleId;
  int? selectedDepartmentId = user.departmentId;
  String selectedStatus = user.status;

  final state = ref.read(userNotifierProvider).valueOrNull;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Update User"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Username ──────────────────────────
              TextField(
                controller: username,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              const SizedBox(height: 8),

              // ── Full Name ─────────────────────────
              TextField(
                controller: fullname,
                decoration: const InputDecoration(labelText: "Full Name"),
              ),
              const SizedBox(height: 8),

              // ── Role Dropdown ─────────────────────
              DropdownButtonFormField<int>(
                value: selectedRoleId,
                decoration: const InputDecoration(labelText: "Role"),
                items: (state?.roles ?? [])
                    .map(
                      (r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.roleName),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedRoleId = val),
              ),
              const SizedBox(height: 8),

              // ── Department Dropdown ───────────────
              DropdownButtonFormField<int?>(
                value: selectedDepartmentId,
                decoration: const InputDecoration(labelText: "Department"),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text("No Department"),
                  ),
                  ...(state?.departments ?? []).map(
                    (d) => DropdownMenuItem(
                      value: d.departmentId,
                      child: Text(d.departmentName),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => selectedDepartmentId = val),
              ),
              const SizedBox(height: 8),

              // ── Status Dropdown ───────────────────
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text("Active")),
                  DropdownMenuItem(value: 'inactive', child: Text("Inactive")),
                ],
                onChanged: (val) =>
                    setState(() => selectedStatus = val ?? 'active'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (username.text.trim().isEmpty ||
                  fullname.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Username and Full Name are required"),
                  ),
                );
                return;
              }
              Navigator.pop(context);
              await ref
                  .read(userNotifierProvider.notifier)
                  .updateUser(
                    UpdateUsersParams(
                      userId: user.id,
                      username: username.text.trim(),
                      fullName: fullname.text.trim(),
                      roleId: selectedRoleId ?? user.roleId,
                      departmentId: selectedDepartmentId,
                      status: selectedStatus,
                    ),
                  );
            },
            child: const Text("Update"),
          ),
        ],
      ),
    ),
  );
}
/////////////////////////////////////////////////////////////////////
/// CREATE ROLE DIALOG
/// /////////////////////////////////////////////////////////////////

void showCreateRoleDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Create Role"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: "Role Name"),
      ),
      /////////////////////////////////////////////////////////////
      ///
      /////////////////////////////////////////////////////////////
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isEmpty) return;
            Navigator.pop(context);
            ref
                .read(userNotifierProvider.notifier)
                .createRole(controller.text.trim());
          },
          child: const Text("Create"),
        ),
      ],
    ),
  );
}

///////////////////////////////////////////////////////////////
/// CREATE DEPARTMENT DIALOG
/// //////////////////////////////////////////////////////////

void showCreateDepartmentDialog(
  BuildContext context,
  WidgetRef ref,
  UserState? state,
) {
  final name = TextEditingController();
  int? selectedManagerId;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text("Create Department"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Department Name"),
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: selectedManagerId,
              decoration: const InputDecoration(
                labelText: "Manager (optional)",
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text("No Manager")),
                ...(state?.users ?? []).map(
                  (u) => DropdownMenuItem(value: u.id, child: Text(u.fullName)),
                ),
              ],
              onChanged: (val) => setState(() => selectedManagerId = val),
            ),
          ],
        ),

        /////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (name.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Departement name is required")),
                );
                return;
              }
              Navigator.pop(context);
              ref
                  .read(userNotifierProvider.notifier)
                  .createDepartment(
                    departmentName: name.text.trim(),
                    managerId: selectedManagerId,
                  );
            },
            child: const Text("Create"),
          ),
        ],
      ),
    ),
  );
}
