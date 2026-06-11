import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/update_user_params.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/helper/helper_widgets.dart';
import 'package:go_router/go_router.dart';

class UpdateUserPage extends ConsumerStatefulWidget {
  final UserEntity user;
  const UpdateUserPage({super.key, required this.user});

  @override
  ConsumerState<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends ConsumerState<UpdateUserPage> {
  late final TextEditingController _username;
  late final TextEditingController _fullname;
  late int? _selectedRoleId;
  late int? _selectedDepartmentId;
  late String _selectedStatus;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _username = TextEditingController(text: widget.user.username);
    _fullname = TextEditingController(text: widget.user.fullName);
    _selectedRoleId = widget.user.roleId;
    _selectedDepartmentId = widget.user.departmentId;
    _selectedStatus = widget.user.status;
  }

  @override
  void dispose() {
    _username.dispose();
    _fullname.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_username.text.trim().isEmpty || _fullname.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and Full Name are required')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref
          .read(userNotifierProvider.notifier)
          .updateUser(
            UpdateUsersParams(
              userId: widget.user.id,
              username: _username.text.trim(),
              fullName: _fullname.text.trim(),
              roleId: _selectedRoleId ?? widget.user.roleId,
              departmentId: _selectedDepartmentId,
              status: _selectedStatus,
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

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////
    final state = ref.watch(userNotifierProvider).valueOrNull;
    final deptId = (state?.departments ?? [])
        .map((d) => d.departmentId)
        .toSet();
    final roleIds = (state?.roles ?? []).map((r) => r.id).toSet();

    if (_selectedRoleId != null && !roleIds.contains(_selectedRoleId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedRoleId = null);
      });
    }

    if (_selectedDepartmentId != null &&
        !deptId.contains(_selectedDepartmentId)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedDepartmentId = null);
      });
    }
    ////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
        elevation: 0,
        leading: const UserFormBackButton(),
        title: const Text(
          'Update User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserFormLabel('ACCOUNT INFO'),
            const SizedBox(height: 12),
            UserFormField(
              controller: _username,
              label: 'Username',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            UserFormField(
              controller: _fullname,
              label: 'Full Name',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 24),
            const UserFormLabel('ASSIGNMENT'),
            const SizedBox(height: 12),

            //////////////////////////////////////////////////////////////
            ///
            /////////////////////////////////////////////////////////////
            UserFormDropdown<int>(
              hint: 'Role',
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

            /////////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ////////////////////////////////////////////////////////////
            UserFormDropdown<int?>(
              hint: 'Department',
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

            ////////////////////////////////////////////////////////////
            ///
            ///////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            UserFormDropdown<String>(
              hint: 'Status',
              icon: Icons.toggle_on_outlined,
              value: _selectedStatus,
              items: const [
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
              ],
              onChanged: (val) =>
                  setState(() => _selectedStatus = val ?? 'active'),
            ),
            const SizedBox(height: 32),
            UserFormButton(
              label: 'Update User',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
