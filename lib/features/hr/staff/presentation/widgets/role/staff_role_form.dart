import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import '../../../domain/entities/staff_role_entity.dart';

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
  bool _isSubmitting = false;

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
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final role = StaffRoleEntity(
      id: widget.existing?.id,
      companyId: widget.existing?.companyId ?? 0,
      roleName: _roleNameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      baseSalary: double.parse(_baseSalaryCtrl.text),
      isManager: _isManager,
    );

    final notifier = ref.read(staffRoleNotifierProvider.notifier);

    try {
      _isEditing
          ? await notifier.updates(widget.existing!.id!, role)
          : await notifier.create(role);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Failed to update role: $e'
                  : 'Failed to create role: $e',
            ),
            backgroundColor: Pallets.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

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
              title: Text('Is Manager', style: TextStyle(color: textPrimary)),
              value: _isManager,
              activeColor: Pallets.blurple,
              onChanged: _isSubmitting
                  ? null
                  : (val) => setState(() => _isManager = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
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
    int maxLines = 1,
    String? prefixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        enabled: !_isSubmitting,
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
