import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/helper/helper_widgets.dart';
import 'package:go_router/go_router.dart';

class CreateUserPage extends ConsumerStatefulWidget {
  const CreateUserPage({super.key});

  @override
  ConsumerState<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends ConsumerState<CreateUserPage> {
  final _username = TextEditingController();
  final _fullname = TextEditingController();
  final _password = TextEditingController();
  int? _selectedRoleId;
  int? _selectedDepartmentId;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _fullname.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_username.text.trim().isEmpty ||
        _fullname.text.trim().isEmpty ||
        _password.text.trim().isEmpty ||
        _selectedRoleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    if (_password.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }
    if (_username.text.trim().contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot contain spaces')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await ref
          .read(userNotifierProvider.notifier)
          .createUser(
            RegisterUserParams(
              username: _username.text.trim(),
              password: _password.text.trim(),
              fullName: _fullname.text.trim(),
              roleId: _selectedRoleId!,
              departmentId: _selectedDepartmentId,
            ),
          );
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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider).valueOrNull;
    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
        elevation: 0,
        leading: const UserFormBackButton(),
        title: const Text(
          'Create User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserFormLabel('ACCOUNT INFO'),
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ////////////////////////////////////////////////////////////////////
            UserFormField(
              controller: _username,
              label: 'Username',
              icon: Icons.person_outline_rounded,
            ),
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ////////////////////////////////////////////////////////////////////
            UserFormField(
              controller: _fullname,
              label: 'Full Name',
              icon: Icons.badge_outlined,
            ),
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ////////////////////////////////////////////////////////////////////
            UserFormField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline_rounded,
              obscure: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Pallets.textSecondaryDark,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 24),
            ////////////////////////////////////////////////////////////////////
            const UserFormLabel('ASSIGNMENT'),
            const SizedBox(height: 12),
            UserFormDropdown<int>(
              hint: 'Role *',
              icon: Icons.badge_outlined,
              value: _selectedRoleId,
              items: (state?.roles ?? [])
                  .map(
                    (r) =>
                        DropdownMenuItem(value: r.id, child: Text(r.roleName)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedRoleId = val),
            ),
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ////////////////////////////////////////////////////////////////////
            UserFormDropdown<int?>(
              hint: 'Department (optional)',
              icon: Icons.business_outlined,
              value: _selectedDepartmentId,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('No Department'),
                ),
                ...(state?.departments ?? []).map(
                  (d) => DropdownMenuItem(
                    value: d.departmentId,
                    child: Text(d.departmentName),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => _selectedDepartmentId = val),
            ),

            const SizedBox(height: 32),
            UserFormButton(
              label: 'Create User',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
