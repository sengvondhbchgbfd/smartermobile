import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import '../../domain/entities/staff_role_entity.dart';

class StaffRoleForm extends ConsumerStatefulWidget {
  final StaffRoleEntity? existing;
  const StaffRoleForm({super.key, this.existing});

  @override
  ConsumerState<StaffRoleForm> createState() => _StaffRoleFormState();
}

class _StaffRoleFormState extends ConsumerState<StaffRoleForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _roleNameCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _baseSalaryCtrl;
  late bool _isManager;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _roleNameCtrl = TextEditingController(text: e?.roleName ?? '');
    _descriptionCtrl = TextEditingController(text: e?.description ?? '');
    _baseSalaryCtrl = TextEditingController(
      text: e?.baseSalary.toString() ?? '0',
    );
    _isManager = e?.isManager ?? false;
  }

  @override
  void dispose() {
    for (final c in [_roleNameCtrl, _descriptionCtrl, _baseSalaryCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final role = StaffRoleEntity(
      id: widget.existing?.id,
      companyId: widget.existing?.companyId ?? 0,
      roleName: _roleNameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      baseSalary: double.parse(_baseSalaryCtrl.text),
      isManager: _isManager,
    );

    final notifier = ref.read(staffRoleNotifierProvider.notifier);
    _isEditing
        ? await notifier.updates(widget.existing!.id!, role)
        : await notifier.create(role);

    if (mounted) Navigator.of(context).pop();
  }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing ? 'Edit Staff Role' : 'Create Staff Role',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _field(_roleNameCtrl, 'Role Name'),
            _field(_descriptionCtrl, 'Description', maxLines: 2),
            _field(
              _baseSalaryCtrl,
              'Base Salary',
              prefixText: '\$ ',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
            SwitchListTile(
              title: const Text('Is Manager'),
              value: _isManager,
              onChanged: (val) => setState(() => _isManager = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label, {
    int maxLines = 1,
    String? prefixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixText: prefixText,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator:
            validator ??
            (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
