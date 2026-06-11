import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';

class StaffForm extends ConsumerStatefulWidget {
  final StaffEntity? existing;
  final VoidCallback? onGoToRoles;
  const StaffForm({super.key, this.existing, this.onGoToRoles});
  @override
  ConsumerState<StaffForm> createState() => _StaffFormState();
}

//////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////

class _StaffFormState extends ConsumerState<StaffForm> {
  ////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _dobCtrl;
  late String _gender;
  int? _selectedRoleId;
  int? _selectedUserId;
  bool get _isEditing => widget.existing != null;
  ////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _emailCtrl = TextEditingController(text: e?.email ?? '');
    _phoneCtrl = TextEditingController(text: e?.phone ?? '');
    _addressCtrl = TextEditingController(text: e?.address ?? '');
    _dobCtrl = TextEditingController(text: e?.dateOfBirth ?? '');
    _gender = e?.gender ?? 'male';
    _selectedRoleId = e?.staffRoleId;
    _selectedUserId = e?.userId;

    Future.microtask(
      () => ref.read(staffRoleNotifierProvider.notifier).fetchAll(),
    );
  }

  //////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _dobCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  ///////////////////////////////////////////
  ///
  //////////////////////////////////////////

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(staffNotifierProvider.notifier);
    if (_isEditing) {
      await notifier.updates(
        widget.existing!.id!,
        UpdateStaffRequest(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          dateOfBirth: _dobCtrl.text.trim(),
          gender: _gender,
          staffRoleId: _selectedRoleId,
        ),
      );
    } else {
      await notifier.create(
        StaffEntity(
          userId: _selectedUserId,
          staffRoleId: _selectedRoleId,
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
          dateOfBirth: _dobCtrl.text.trim(),
          gender: _gender,
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  ////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobCtrl.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  ///////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit Staff' : 'Create Staff',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              _field(_nameCtrl, 'Full Name'),

              _field(
                _emailCtrl,
                'Email',
                keyboardType: TextInputType.emailAddress,
              ),

              _field(_phoneCtrl, 'Phone', keyboardType: TextInputType.phone),
              _field(_addressCtrl, 'Address', maxLines: 2),
              _dateField(),
              _genderDropdown(),
              if (!_isEditing) _userDropdown(),
              _roleDropdown(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isEditing ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////
  ///  Helper
  /////////////////////////////////////////////////////////
  Widget _field(
    TextEditingController ctrl,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }

  /////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _dobCtrl,
        readOnly: true,
        onTap: _pickDate,
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }

  ///////////////////////////////////////////
  ///
  //////////////////////////////////////////

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: _gender,
        decoration: const InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Male')),
          DropdownMenuItem(value: 'female', child: Text('Female')),
        ],
        onChanged: (val) => setState(() => _gender = val!),
      ),
    );
  }

  //////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////

  Widget _userDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ref
          .watch(userNotifierProvider)
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text(
              'Failed to load users: $e',
              style: const TextStyle(color: Colors.red),
            ),
            data: (state) => DropdownButtonFormField<int>(
              initialValue: _selectedUserId,
              decoration: const InputDecoration(
                labelText: 'Link to User Account',
                border: OutlineInputBorder(),
              ),
              items: state.users
                  .map(
                    (u) => DropdownMenuItem(
                      value: u.id,
                      child: Text(u.fullName ?? u.username),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _selectedUserId = val),
              validator: (v) => v == null ? 'Please select a user' : null,
            ),
          ),
    );
  }

  ////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////

  Widget _roleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ref
          .watch(staffRoleNotifierProvider)
          .when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text(
              'Failed to load roles: $e',
              style: const TextStyle(color: Colors.red),
            ),
            data: (roles) => roles.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'No roles available. Please create a staff role first.',
                        style: TextStyle(color: Colors.orange),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onGoToRoles?.call();
                        },
                        child: const Text('Go to Staff Roles'),
                      ),
                    ],
                  )
                : DropdownButtonFormField<int>(
                    initialValue: _selectedRoleId,
                    decoration: const InputDecoration(
                      labelText: 'Staff Role',
                      border: OutlineInputBorder(),
                    ),
                    items: roles
                        .map(
                          (r) => DropdownMenuItem(
                            value: r.id,
                            child: Text(r.roleName),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _selectedRoleId = val),
                    validator: (v) => v == null ? 'Please select a role' : null,
                  ),
          ),
    );
  }
}
