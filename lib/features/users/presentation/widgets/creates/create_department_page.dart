import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/helper/helper_widgets.dart';
import 'package:go_router/go_router.dart';

class CreateDepartmentPage extends ConsumerStatefulWidget {
  const CreateDepartmentPage({super.key});

  @override
  ConsumerState<CreateDepartmentPage> createState() =>
      _CreateDepartmentPageState();
}

class _CreateDepartmentPageState extends ConsumerState<CreateDepartmentPage> {
  final _name = TextEditingController();
  int? _selectedManagerId;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Department name is required')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref
          .read(userNotifierProvider.notifier)
          .createDepartment(
            departmentName: _name.text.trim(),
            managerId: _selectedManagerId,
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
    final state = ref.watch(userNotifierProvider).valueOrNull;

    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
        elevation: 0,
        leading: const UserFormBackButton(),
        title: const Text(
          'Create Department',
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
            const UserFormLabel('DEPARTMENT DETAILS'),
            const SizedBox(height: 12),
            UserFormField(
              controller: _name,
              label: 'Department Name',
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 24),
            const UserFormLabel('MANAGER (OPTIONAL)'),
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ////////////////////////////////////////////////////////////////////
            UserFormDropdown<int?>(
              hint: 'Select Manager',
              icon: Icons.person_outline_rounded,
              value: _selectedManagerId,
              items: [
                const DropdownMenuItem(value: null, child: Text('No Manager')),
                ...(state?.users ?? []).map(
                  (u) => DropdownMenuItem(value: u.id, child: Text(u.fullName)),
                ),
              ],
              onChanged: (val) => setState(() => _selectedManagerId = val),
            ),

            /////////////////////////////////////////////////////////////////
            const SizedBox(height: 32),
            ////////////////////////////////////////////////////////////////
            UserFormButton(
              label: 'Create Department',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
