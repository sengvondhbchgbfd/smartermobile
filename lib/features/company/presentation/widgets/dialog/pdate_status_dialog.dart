import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';

const _statuses = ['active', 'suspended', 'cancelled'];
const _statusExplanations = {
  'active': 'Company shows as active across the app. No restrictions apply.',
  'suspended':
      'This updates the status label and records the change in the '
      'audit log. It does not currently sign anyone out or block '
      'access — existing sessions keep working as normal.',
  'cancelled':
      'This updates the status label and records the change in the '
      'audit log. It does not currently sign anyone out, block access, '
      'or delete the company or its data.',
};

Future<void> showUpdateStatusDialog({
  required BuildContext context,
  required WidgetRef ref,
  required int companyId,
  required String currentStatus,
}) {
  return showDialog(
    context: context,
    builder: (_) =>
        _UpdateStatusDialog(companyId: companyId, currentStatus: currentStatus),
  );
}

class _UpdateStatusDialog extends ConsumerStatefulWidget {
  final int companyId;
  final String currentStatus;
  const _UpdateStatusDialog({
    required this.companyId,
    required this.currentStatus,
  });

  @override
  ConsumerState<_UpdateStatusDialog> createState() =>
      _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends ConsumerState<_UpdateStatusDialog> {
  late String _selected;
  final _reasonCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentStatus.toLowerCase();
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return Pallets.success;
      case 'suspended':
        return Colors.orange;
      case 'cancelled':
        return Pallets.error;
      default:
        return Colors.grey;
    }
  }

  Future<void> _submit() async {
    if (_selected == widget.currentStatus.toLowerCase()) {
      Navigator.pop(context);
      return;
    }

    setState(() => _submitting = true);

    final success = await ref
        .read(companyProvider.notifier)
        .updateCompanyStatus(
          companyId: widget.companyId,
          status: _selected,
          reason: _reasonCtrl.text.trim().isEmpty
              ? null
              : _reasonCtrl.text.trim(),
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Company status updated'),
            ],
          ),
          backgroundColor: Pallets.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      final error =
          ref.read(companyProvider).valueOrNull?.error ??
          'Failed to update status';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(error)),
            ],
          ),
          backgroundColor: Pallets.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final surf = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final fill = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;
    final selectedColor = _statusColor(_selected);

    return AlertDialog(
      backgroundColor: surf,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Update Company Status',
        style: TextStyle(color: t1, fontWeight: FontWeight.w700, fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                color: t2,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _statuses.map((s) {
                final selected = _selected == s;
                final color = _statusColor(s);
                return ChoiceChip(
                  label: Text(s),
                  selected: selected,
                  onSelected: (_) => setState(() => _selected = s),
                  selectedColor: color.withOpacity(0.18),
                  backgroundColor: fill,
                  labelStyle: TextStyle(
                    color: selected ? color : t2,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  side: BorderSide(color: selected ? color : border),
                );
              }).toList(),
            ),

            // ── Live explanation panel — updates on every chip tap ─────
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Container(
                key: ValueKey(_selected),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selectedColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: selectedColor.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: selectedColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _statusExplanations[_selected] ?? '',
                        style: TextStyle(
                          color: selectedColor,
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Reason (optional)',
              style: TextStyle(
                color: t2,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonCtrl,
              maxLines: 3,
              style: TextStyle(color: t1, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Why is this status changing?',
                hintStyle: TextStyle(color: t2.withOpacity(0.6), fontSize: 12),
                filled: true,
                fillColor: fill,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Pallets.blurple,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: t2)),
        ),
        ElevatedButton(
          onPressed: _submitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Pallets.blurple,
            disabledBackgroundColor: Pallets.blurple.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: _submitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Update',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }
}
