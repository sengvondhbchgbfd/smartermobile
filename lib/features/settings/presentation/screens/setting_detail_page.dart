import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';
import 'package:frontendmobile/features/settings/presentation/providers/settings_provider.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/_setting_form_helpers.dart';
import 'package:go_router/go_router.dart';

class SettingDetailPage extends ConsumerStatefulWidget {
  final String settingKey;
  final String label;
  final SystemSettingEntity? existing;

  const SettingDetailPage({
    super.key,
    required this.settingKey,
    required this.label,
    required this.existing,
  });

  @override
  ConsumerState<SettingDetailPage> createState() => _SettingDetailPageState();
}

class _SettingDetailPageState extends ConsumerState<SettingDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _valueCtrl = TextEditingController(text: widget.existing?.value ?? '');
    _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final bool ok;
    if (_isEdit) {
      ok = await ref
          .read(settingsProvider.notifier)
          .update(
            settingId: widget.existing!.settingId,
            value: _valueCtrl.text.trim(),
            description: _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
          );
    } else {
      ok = await ref
          .read(settingsProvider.notifier)
          .create(
            key: widget.settingKey,
            value: _valueCtrl.text.trim(),
            description: _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
          );
    }

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to ${_isEdit ? 'update' : 'create'} setting.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surfaceColor = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textSecondary),
          onPressed: () => context.pop(false),
        ),
        title: Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: Pallets.gradient2,
                foregroundColor: Colors.white,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isEdit ? 'Save' : 'Create'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Key badge
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Pallets.borderDark : Pallets.borderLight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.key_outlined, size: 16, color: textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.settingKey,
                      style: TextStyle(
                        color: textSecondary,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Pallets.borderDark : Pallets.borderLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'read-only',
                      style: TextStyle(fontSize: 10, color: textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SectionLabel('Value'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _valueCtrl,
              autofocus: true,
              style: TextStyle(color: textPrimary),
              decoration: inputDecoration(context, hint: 'Enter value'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Value is required' : null,
            ),
            const SizedBox(height: 20),
            SectionLabel('Description'),
            const SizedBox(height: 4),
            Text(
              'Optional — short explanation of this setting.',
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              style: TextStyle(color: textPrimary),
              decoration: inputDecoration(context, hint: 'Short description'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
