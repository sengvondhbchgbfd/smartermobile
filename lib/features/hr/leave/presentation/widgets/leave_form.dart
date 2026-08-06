import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/themes/leave_pallets.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import '../widgets/date_scroll_picker.dart';

class SubmitLeaveForm extends ConsumerStatefulWidget {
  const SubmitLeaveForm({super.key});

  // ── Full-screen route ─────────────────────────────────────────────────────
  static Route<void> route() => MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => const SubmitLeaveForm(),
  );

  @override
  ConsumerState<SubmitLeaveForm> createState() => _SubmitLeaveFormState();
}

class _SubmitLeaveFormState extends ConsumerState<SubmitLeaveForm> {
  LeaveType _selectedType = LeaveType.annual;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // ── Computed ──────────────────────────────────────────────────────────────
  int get _days => _endDate.difference(_startDate).inDays + 1;

  // ── Date pickers ──────────────────────────────────────────────────────────
  Future<void> _pickStart() => DateScrollPicker.show(
    context: context,
    title: 'Start date',
    initialDate: DateUtils.dateOnly(_startDate),
    firstDate: DateUtils.dateOnly(DateTime.now()),
    onChanged: (d) => setState(() {
      _startDate = DateUtils.dateOnly(d);
      if (_endDate.isBefore(_startDate)) {
        _endDate = _startDate.add(const Duration(days: 1));
      }
    }),
  );

  Future<void> _pickEnd() => DateScrollPicker.show(
    context: context,
    title: 'End date',
    initialDate: _endDate,
    firstDate: _startDate,
    onChanged: (d) => setState(() => _endDate = d),
  );

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> _submit(LeavePalette p) async {
    setState(() => _isSubmitting = true);
    try {
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
      if (!mounted) return;
      if (state?.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state!.error!),
            backgroundColor: Pallets.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Leave request submitted'),
            backgroundColor: Pallets.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = LeavePalette.of(isDark);

    ref.listen(staffLeaveProvider, (prev, next) {
      final error = next.value?.error;
      if (error != null && error != prev?.value?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Pallets.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        ref.read(staffLeaveProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: p.bg,

      // ── AppBar ─────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: p.card,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: p.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.close_rounded, color: p.textPrimary, size: 20),
          ),
        ),
        title: Text(
          'Request time off',
          style: TextStyle(
            color: p.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      // ── Body ───────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Leave type ──────────────────────────────────────────────
            _SectionLabel(label: 'Leave type', color: p.textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<LeaveType>(
                  value: _selectedType,
                  dropdownColor: p.card,
                  style: TextStyle(
                    color: p.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: p.textSecondary,
                  ),
                  items: LeaveType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: LeaveTypeColor.of(t),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                '${t.name[0].toUpperCase()}${t.name.substring(1)}',
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedType = v!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Date range ──────────────────────────────────────────────
            _SectionLabel(label: 'Date range', color: p.textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              child: Column(
                children: [
                  _DateTile(
                    label: 'Start date',
                    value: DateFormatter.fmt(_startDate),
                    textPrimary: p.textPrimary,
                    textSecondary: p.textSecondary,
                    accent: p.accent,
                    onTap: _pickStart,
                  ),
                  Divider(height: 1, color: p.border),
                  _DateTile(
                    label: 'End date',
                    value: DateFormatter.fmt(_endDate),
                    textPrimary: p.textPrimary,
                    textSecondary: p.textSecondary,
                    accent: p.accent,
                    onTap: _pickEnd,
                  ),
                ],
              ),
            ),

            // ── Days summary pill ───────────────────────────────────────
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: p.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$_days ${_days == 1 ? 'day' : 'days'} selected',
                  style: TextStyle(
                    color: p.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Reason ──────────────────────────────────────────────────
            _SectionLabel(label: 'Reason (optional)', color: p.textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: p.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              child: TextField(
                controller: _reasonController,
                maxLines: 4,
                style: TextStyle(color: p.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Add a note for your manager…',
                  hintStyle: TextStyle(color: p.textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Submit ──────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.accent,
                  foregroundColor: Pallets.onAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isSubmitting ? null : () => _submit(p),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit request',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SectionLabel
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DateTile
// ─────────────────────────────────────────────────────────────────────────────
class _DateTile extends StatelessWidget {
  final String label, value;
  final Color textPrimary, textSecondary, accent;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 16, color: accent),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}
