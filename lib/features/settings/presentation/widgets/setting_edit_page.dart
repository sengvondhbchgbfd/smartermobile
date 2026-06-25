import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/_setting_form_helpers.dart'
    show SectionLabel, inputDecoration;
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';
import 'package:frontendmobile/features/settings/presentation/providers/settings_provider.dart';

class SettingEditPage extends ConsumerStatefulWidget {
  final SystemSettingEntity setting;
  const SettingEditPage({required this.setting, super.key});
  @override
  ConsumerState<SettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends ConsumerState<SettingEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _valueCtrl = TextEditingController(text: widget.setting.value);
    _descCtrl = TextEditingController(text: widget.setting.description);
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
    final ok = await ref
        .read(settingsProvider.notifier)
        .update(
          settingId: widget.setting.settingId,
          value: _valueCtrl.text.trim(),
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update setting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ← theme-aware variables
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surfaceColor = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final cardColor = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final textPrimary = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final textSecondary = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;

    return Scaffold(
      backgroundColor: bgColor,                              // ← was backgroundDark
      appBar: AppBar(
        backgroundColor: surfaceColor,                       // ← was surfaceDark
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textSecondary),     // ← was Colors.white70
          onPressed: () => context.pop(false),
        ),
        title: Text(
          'Edit Setting',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textPrimary,                             // ← was Colors.white
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: Pallets.gradient2,         // ← was hardcoded blue
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
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor,                           // ← was surfaceCard
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),    // ← added border
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.key_outlined,
                    size: 16,
                    color: textSecondary,                  // ← was surfaceElevated
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.setting.key,
                      style: TextStyle(
                        color: textSecondary,              // ← was hardcoded
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
                      color: borderColor,                  // ← was hardcoded
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'read-only',
                      style: TextStyle(
                        fontSize: 10,
                        color: textSecondary,             // ← was hardcoded
                      ),
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
              style: TextStyle(color: textPrimary),       // ← was Colors.white
              decoration: inputDecoration(context, hint: 'Setting value'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Value is required' : null,
            ),
            const SizedBox(height: 20),
            SectionLabel('Description'),
            const SizedBox(height: 4),
            Text(
              'Optional — short explanation of this setting.',
              style: TextStyle(fontSize: 12, color: textSecondary), // ← was hardcoded
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              style: TextStyle(color: textPrimary),       // ← was Colors.white
              decoration: inputDecoration(
                context,
                hint: 'e.g. Office latitude coordinate',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}