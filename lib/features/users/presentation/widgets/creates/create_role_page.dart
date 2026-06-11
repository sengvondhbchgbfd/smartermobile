import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/helper/helper_widgets.dart';
import 'package:go_router/go_router.dart';

class CreateRolePage extends ConsumerStatefulWidget {
  const CreateRolePage({super.key});

  @override
  ConsumerState<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends ConsumerState<CreateRolePage> {
  final _roleName = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _roleName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_roleName.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Role name is required')));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref
          .read(userNotifierProvider.notifier)
          .createRole(_roleName.text.trim());

      final error = ref.read(userNotifierProvider).valueOrNull?.errorMessage;
      if (mounted && error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        return;
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
        elevation: 0,
        leading: const UserFormBackButton(),
        title: const Text(
          'Create Role',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserFormLabel('ROLE DETAILS'),
            const SizedBox(height: 12),
            UserFormField(
              controller: _roleName,
              label: 'Role Name',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 32),
            UserFormButton(
              label: 'Create Role',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
