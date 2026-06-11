import 'package:flutter/material.dart';
import '../../domain/entities/system_setting_entity.dart';

// ---------------------------------------------------------------------------
// Setting tile
// ---------------------------------------------------------------------------

class SettingTile extends StatelessWidget {
  final SystemSettingEntity setting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SettingTile({
    required this.setting,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          setting.key,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              setting.value ?? '—',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: setting.value != null
                    ? colors.onSurfaceVariant
                    : colors.outline,
                fontStyle: setting.value == null ? FontStyle.italic : null,
              ),
            ),
            if (setting.description != null) ...[
              const SizedBox(height: 4),
              Text(
                setting.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.outline,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colors.primary),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colors.error),
              tooltip: 'Delete',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Setting form dialog  (create / edit)
// ---------------------------------------------------------------------------

class SettingFormDialog extends StatefulWidget {
  final SystemSettingEntity? existing; // null = create mode

  const SettingFormDialog({this.existing, super.key});

  @override
  State<SettingFormDialog> createState() => _SettingFormDialogState();
}

class _SettingFormDialogState extends State<SettingFormDialog> {
  final _formKey    = GlobalKey<FormState>();
  late final TextEditingController _keyCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _descCtrl;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _keyCtrl   = TextEditingController(text: widget.existing?.key);
    _valueCtrl = TextEditingController(text: widget.existing?.value);
    _descCtrl  = TextEditingController(text: widget.existing?.description);
  }

  @override
  void dispose() {
    _keyCtrl.dispose();
    _valueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop({
      'key':         _keyCtrl.text.trim(),
      'value':       _valueCtrl.text.trim(),
      'description': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = theme.colorScheme;

    return AlertDialog(
      title: Text(_isEdit ? 'Edit Setting' : 'New Setting'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Key
              TextFormField(
                controller: _keyCtrl,
                readOnly:   _isEdit,  // key is immutable after create
                decoration: InputDecoration(
                  labelText:  'Key',
                  hintText:   'e.g. attendance_grace_minutes',
                  filled:     true,
                  fillColor:  _isEdit ? colors.surfaceVariant : null,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Key is required' : null,
              ),
              const SizedBox(height: 12),
              // Value
              TextFormField(
                controller: _valueCtrl,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText:  'e.g. 15',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Value is required' : null,
              ),
              const SizedBox(height: 12),
              // Description
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText:  'Short explanation of this setting',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Delete confirmation dialog
// ---------------------------------------------------------------------------

class DeleteConfirmDialog extends StatelessWidget {
  final String settingKey;

  const DeleteConfirmDialog({required this.settingKey, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Setting'),
      content: Text(
        'Are you sure you want to delete "$settingKey"? This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class SettingsEmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const SettingsEmptyState({required this.onAdd, super.key});

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tune_outlined,
            size: 64,
            color: colors.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No settings yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first system setting to get started.',
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Setting'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error banner
// ---------------------------------------------------------------------------

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;

  const ErrorBanner({
    required this.message,
    required this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:        colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.error),
            onPressed: onDismiss,
          ),
        ],
      ),
    );
  }
}