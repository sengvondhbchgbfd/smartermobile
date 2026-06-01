import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/data/model/salaries_adjust_model.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/presentation/provider/salary_adjustment_provider.dart';

class CreateAdjustmentSheet extends ConsumerStatefulWidget {
  final int salaryId;
  const CreateAdjustmentSheet({super.key, required this.salaryId});

  @override
  ConsumerState<CreateAdjustmentSheet> createState() =>
      _CreateAdjustmentSheetState();
}

class _CreateAdjustmentSheetState extends ConsumerState<CreateAdjustmentSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = 'bonus';

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) return;

    ref
        .read(adjustmentNotifierProvider(widget.salaryId).notifier)
        .create(
          SalaryAdjustmentCreateDto(
            salaryId: widget.salaryId,
            type: _type,
            amount: amount,
            note: _noteController.text.isEmpty ? null : _noteController.text,
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Adjustment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'bonus',
                    label: Text('Bonus'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment(
                    value: 'deduction',
                    label: Text('Deduction'),
                    icon: Icon(Icons.remove),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (v) => setState(() => _type = v.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
