import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/salary_adjustment_entity.dart';
import '../provider/salary_adjustment_provider.dart';

class CreateAdjustmentSheet extends ConsumerStatefulWidget {
  final int salaryId;

  const CreateAdjustmentSheet({super.key, required this.salaryId});

  @override
  ConsumerState<CreateAdjustmentSheet> createState() =>
      _CreateAdjustmentSheetState();
}

class _CreateAdjustmentSheetState
    extends ConsumerState<CreateAdjustmentSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  AdjustmentType _selectedType = AdjustmentType.bonus;

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(salaryAdjustmentNotifierProvider.notifier).createAdjustment(
          salaryId: widget.salaryId,
          adjustmentType: _selectedType,
          amount: double.parse(_amountController.text.trim()),
          reason: _reasonController.text.trim().isEmpty
              ? null
              : _reasonController.text.trim(),
        );

    if (mounted) {
      final state = ref.read(salaryAdjustmentNotifierProvider);
      if (state.error == null) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSubmitting =
        ref.watch(salaryAdjustmentNotifierProvider).isSubmitting;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'New Adjustment',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Salary #${widget.salaryId}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
            ),
            const SizedBox(height: 24),

            // Type toggle
            Text('Type',
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _TypeToggle(
              selected: _selectedType,
              onChanged: (t) => setState(() => _selectedType = t),
            ),
            const SizedBox(height: 20),

            // Amount field
            Text('Amount',
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: _inputDecoration(
                context,
                hintText: '0.00',
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 12, right: 8),
                  child: Text('\$',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Amount is required';
                final parsed = double.tryParse(v.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid positive amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Reason field
            Text('Reason (optional)',
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              maxLength: 200,
              decoration: _inputDecoration(
                context,
                hintText: 'e.g. Performance bonus Q2...',
              ),
            ),
            const SizedBox(height: 24),

            // Submit
            FilledButton(
              onPressed: isSubmitting ? null : _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Create Adjustment',
                      style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    Widget? prefix,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hintText,
      prefix: prefix,
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 1.5),
      ),
    );
  }
}

// ── Type Toggle ────────────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  final AdjustmentType selected;
  final ValueChanged<AdjustmentType> onChanged;

  const _TypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _ToggleOption(
          label: 'Bonus',
          icon: Icons.arrow_upward_rounded,
          isSelected: selected == AdjustmentType.bonus,
          selectedColor: Colors.green.shade600,
          selectedBg: Colors.green.shade50,
          onTap: () => onChanged(AdjustmentType.bonus),
          theme: theme,
        ),
        const SizedBox(width: 12),
        _ToggleOption(
          label: 'Deduction',
          icon: Icons.arrow_downward_rounded,
          isSelected: selected == AdjustmentType.deduction,
          selectedColor: Colors.red.shade600,
          selectedBg: Colors.red.shade50,
          onTap: () => onChanged(AdjustmentType.deduction),
          theme: theme,
        ),
      ],
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final Color selectedBg;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ToggleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.selectedBg,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedBg
                : theme.colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? selectedColor.withOpacity(0.6)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? selectedColor
                      : theme.colorScheme.onSurface.withOpacity(0.5)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? selectedColor
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}