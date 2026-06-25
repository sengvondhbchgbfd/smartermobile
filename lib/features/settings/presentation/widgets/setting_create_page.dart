import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/_setting_form_helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/features/settings/presentation/providers/settings_provider.dart';

class SettingCreatePage extends ConsumerStatefulWidget {
  final String? prefillKey;
  final String? prefillHint;

  const SettingCreatePage({this.prefillKey, this.prefillHint, super.key});

  @override
  ConsumerState<SettingCreatePage> createState() => _SettingCreatePageState();
}

class _SettingCreatePageState extends ConsumerState<SettingCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _keyCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  bool get _keyLocked => widget.prefillKey != null;

  @override
  void initState() {
    super.initState();
    _keyCtrl = TextEditingController(text: widget.prefillKey ?? '');
    _valueCtrl = TextEditingController();
    _descCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _keyCtrl.dispose();
    _valueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final ok = await ref
        .read(settingsProvider.notifier)
        .create(
          key: _keyCtrl.text.trim(),
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
        const SnackBar(content: Text('Failed to create setting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ← theme-aware variables
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
      backgroundColor: bgColor, // ← was backgroundDark
      appBar: AppBar(
        backgroundColor: surfaceColor, // ← was surfaceDark
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textSecondary), // ← was Colors.white70
          onPressed: () => context.pop(false),
        ),
        title: Text(
          _keyLocked ? widget.prefillKey! : 'New Setting',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: textPrimary, // ← was Colors.white
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: Pallets.gradient2, // ← was hardcoded blue
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
                  : const Text('Create'),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionLabel('Key'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _keyCtrl,
              readOnly: _keyLocked,
              style: TextStyle(color: textPrimary), // ← was Colors.white
              decoration: inputDecoration(
                context,
                hint: widget.prefillHint ?? 'e.g. currency_code',
                locked: _keyLocked,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Key is required' : null,
            ),
            const SizedBox(height: 20),
            SectionLabel('Value'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _valueCtrl,
              autofocus: true,
              style: TextStyle(color: textPrimary), // ← was Colors.white
              decoration: inputDecoration(
                context,
                hint: widget.prefillHint ?? 'Setting value',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Value is required' : null,
            ),
            const SizedBox(height: 20),
            SectionLabel('Description'),
            const SizedBox(height: 4),
            Text(
              'Optional — short explanation.',
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
              ), // ← was hardcoded
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              style: TextStyle(color: textPrimary), // ← was Colors.white
              decoration: inputDecoration(context, hint: 'Short description'),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
