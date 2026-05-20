import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';

class UserForm extends ConsumerStatefulWidget {
  const UserForm({super.key});
  @override
  ConsumerState<UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();

  int? roleId;
  int? departmentId;

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_usernameController.text.isEmpty || _fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username and Full Name are required")),
      );
      return;
    }

    if (roleId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a role")));
      return;
    }

    final storage = ref.read(secureStorageProvider);

    final companyIdStr = await storage.getCompanyId();

    if (companyIdStr == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Company ID not found")));
      }
      return;
    }

    final params = RegisterUserParams(
      username: _usernameController.text.trim(),
      password: "123456",
      fullName: _fullNameController.text.trim(),
      roleId: roleId!,
      departmentId: departmentId,
      // companyId: int.parse(companyIdStr),
    );

    await ref.read(userNotifierProvider.notifier).createUser(params);

    if (!context.mounted) return;

    final state = ref.read(userNotifierProvider);

    final errorMessage = state.value?.errorMessage;

    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User created successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);

    final isLoading = state.value?.isLoading ?? false;

    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(labelText: "Username"),
        ),

        TextField(
          controller: _fullNameController,
          decoration: const InputDecoration(labelText: "Full Name"),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Create User"),
        ),
      ],
    );
  }
}
