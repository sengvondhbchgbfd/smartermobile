import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';

class StaffForm extends ConsumerStatefulWidget {
  final StaffEntity? existing;
  final VoidCallback? onGoToRoles;
  const StaffForm({super.key, this.existing, this.onGoToRoles});
  @override
  ConsumerState<StaffForm> createState() => _StaffFormState();
}
class _StaffFormState extends ConsumerState<StaffForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _dobCtrl;
  late String _gender;
  int? _selectedRoleId;
  int? _selectedUserId;
  bool _isSubmitting = false;
  bool get _isEditing => widget.existing != null;

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

  // ── SUBMIT ─────────────────────────────────────────────────
  Future<void> _submit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final notifier = ref.read(staffNotifierProvider.notifier);

    try {
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
        ref.read(profileNotifierProvider.notifier).refresh();
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
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Failed to update staff: $e'
                  : 'Failed to create staff: $e',
            ),
            backgroundColor: Pallets.error,
          ),
        );
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallets.blurple,
                  disabledBackgroundColor: Pallets.blurple.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEditing ? 'Update' : 'Create',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        enabled: !_isSubmitting,
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

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _dobCtrl,
        readOnly: true,
        enabled: !_isSubmitting,
        onTap: _isSubmitting ? null : _pickDate,
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }

  Widget _genderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _gender,
        decoration: const InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Male')),
          DropdownMenuItem(value: 'female', child: Text('Female')),
        ],
        onChanged: _isSubmitting
            ? null
            : (val) => setState(() => _gender = val!),
      ),
    );
  }

  // ── USER DROPDOWN — loading always wins over stale error ──
  Widget _userDropdown() {
    final userState = ref.watch(userNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: userState.when(
        loading: () => _loadingField('Loading users...'),
        error: (e, _) => _errorField(
          'Failed to load users',
          onRetry: () => ref.invalidate(userNotifierProvider),
        ),
        data: (state) => DropdownButtonFormField<int>(
          value: _selectedUserId,
          decoration: const InputDecoration(
            labelText: 'Link to User Account',
            border: OutlineInputBorder(),
          ),
          items: state.users
              .map(
                (u) => DropdownMenuItem(value: u.id, child: Text(u.fullName)),
              )
              .toList(),
          onChanged: _isSubmitting
              ? null
              : (val) => setState(() => _selectedUserId = val),
          validator: (v) => v == null ? 'Please select a user' : null,
        ),
      ),
    );
  }

  // ── ROLE DROPDOWN — loading always wins over stale error ──
  Widget _roleDropdown() {
    final roleState = ref.watch(staffRoleNotifierProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: roleState.when(
        loading: () => _loadingField('Loading roles...'),
        error: (e, _) => _errorField(
          'Failed to load roles',
          onRetry: () =>
              ref.read(staffRoleNotifierProvider.notifier).fetchAll(),
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
                    onPressed: _isSubmitting
                        ? null
                        : () {
                            Navigator.pop(context);
                            widget.onGoToRoles?.call();
                          },
                    child: const Text('Go to Staff Roles'),
                  ),
                ],
              )
            : DropdownButtonFormField<int>(
                value: _selectedRoleId,
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
                onChanged: _isSubmitting
                    ? null
                    : (val) => setState(() => _selectedRoleId = val),
                validator: (v) => v == null ? 'Please select a role' : null,
              ),
      ),
    );
  }

  // ── Shared loading placeholder (shaped like a field, not a raw bar) ──
  Widget _loadingField(String label) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  // ── Shared error placeholder with retry (instead of raw red text) ──
  Widget _errorField(String message, {required VoidCallback onRetry}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Pallets.error),
        borderRadius: BorderRadius.circular(4),
        color: Pallets.errorTint,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Pallets.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Pallets.error)),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
