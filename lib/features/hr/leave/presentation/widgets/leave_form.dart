import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import '../widgets/date_scroll_picker.dart';

class SubmitLeaveForm extends ConsumerStatefulWidget {
  const SubmitLeaveForm({super.key});
  @override
  ConsumerState<SubmitLeaveForm> createState() => _SubmitLeaveFormState();
}

class _SubmitLeaveFormState extends ConsumerState<SubmitLeaveForm> {
  LeaveType _selectedType = LeaveType.annual;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  final _reasonController = TextEditingController();
  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
  // ── date picker ───────────────────────────────────────────────────────────

  Future<void> _pickStart() => DateScrollPicker.show(
    context: context,
    title: 'Start date',
    initialDate: DateUtils.dateOnly(_startDate),
    firstDate: DateUtils.dateOnly(DateTime.now()),
    onChanged: (d) => setState(() {
      _startDate = DateUtils.dateOnly(d);
    }),
  );
  Future<void> _pickEnd() => DateScrollPicker.show(
    context: context,
    title: 'End date',
    initialDate: _endDate,
    firstDate: _startDate,
    onChanged: (d) => setState(() => _endDate = d),
  );

  // ── submit ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    ref.listen(staffLeaveProvider, (prev, next) {
      final error = next.value?.error;
      if (error != null && error != prev?.value?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(staffLeaveProvider.notifier).clearError();
      }
    });
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Request time off',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // ── leave type ────────────────────────────────────────────────────
          DropdownButtonFormField<LeaveType>(
            value: _selectedType,
            items: LeaveType.values
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.name.toUpperCase()),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
            decoration: const InputDecoration(labelText: 'Leave type'),
          ),
          const SizedBox(height: 8),

          // ── start date ────────────────────────────────────────────────────
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Start date',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            subtitle: Text(
              DateFormatter.fmt(_startDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickStart,
          ),
          const Divider(height: 1),

          // ── end date ──────────────────────────────────────────────────────
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'End date',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            subtitle: Text(
              DateFormatter.fmt(_endDate),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickEnd,
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // ── reason ────────────────────────────────────────────────────────
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(labelText: 'Reason (optional)'),
          ),
          const SizedBox(height: 24),

          // ── submit ────────────────────────────────────────────────────────
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await ref
                  .read(staffLeaveProvider.notifier)
                  .submitLeave(
                    leaveType: _selectedType,
                    startDate: _startDate,
                    endDate: _endDate,
                    reason: _reasonController.text.isEmpty
                        ? null
                        : _reasonController.text,
                  );
              final state = ref.read(staffLeaveProvider).value;
              if (context.mounted) {
                if (state?.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state!.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Leave request submitted successfully'),
                    ),
                  );
                }
              }
            },
            child: const Text('Submit request', style: TextStyle(fontSize: 16)),
          ),

          /////////////////////////////////////////////////////////////////////
          ///
          /////////////////////////////////////////////////////////////////////
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
