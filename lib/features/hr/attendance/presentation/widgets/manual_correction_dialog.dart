import 'package:flutter/material.dart';
import '../../domain/entities/attendance_entity.dart';

class CorrectionResult {
  const CorrectionResult({
    required this.checkIn,
    required this.checkOut,
    required this.reason,
  });

  final TimeOfDay? checkIn;
  final TimeOfDay? checkOut;
  final String reason;
}

class ManualCorrectionDialog extends StatefulWidget {
  const ManualCorrectionDialog({super.key, required this.record});

  final AttendanceEntity record;

  /// Convenience launcher – returns null if cancelled.
  static Future<CorrectionResult?> show(
    BuildContext context,
    AttendanceEntity record,
  ) {
    return showDialog<CorrectionResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ManualCorrectionDialog(record: record),
    );
  }

  @override
  State<ManualCorrectionDialog> createState() => _ManualCorrectionDialogState();
}

class _ManualCorrectionDialogState extends State<ManualCorrectionDialog> {
  TimeOfDay? _checkIn;
  TimeOfDay? _checkOut;
  final _reasonController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _checkIn = _parseTime(widget.record.checkInTime);
    _checkOut = _parseTime(widget.record.checkOutTime);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    // Expects "HH:mm" or "HH:mm:ss".
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  Future<void> _pickTime({required bool isCheckIn}) async {
    final initial = (isCheckIn ? _checkIn : _checkOut) ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: isCheckIn ? 'Select Check-In Time' : 'Select Check-Out Time',
    );
    if (picked == null) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
      } else {
        _checkOut = picked;
      }
    });
  }

  void _submit() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reason for the correction.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    Navigator.pop(
      context,
      CorrectionResult(
        checkIn: _checkIn,
        checkOut: _checkOut,
        reason: _reasonController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.edit_calendar, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('Manual Correction', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Staff info
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Staff #${widget.record.attendanceId}  ·  ${widget.record.date ?? 'Unknown date'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Check-In Time',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _TimePicker(
              time: _checkIn,
              placeholder: 'Not set',
              onTap: () => _pickTime(isCheckIn: true),
            ),

            const SizedBox(height: 14),
            const Text(
              'Check-Out Time',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _TimePicker(
              time: _checkOut,
              placeholder: 'Not set',
              onTap: () => _pickTime(isCheckIn: false),
            ),

            const SizedBox(height: 16),
            const Text(
              'Reason *',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. System error, forgot to check out…',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
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
      ],
    );
  }
}

// ── Time picker button ─────────────────────────────────────────────────────

class _TimePicker extends StatelessWidget {
  const _TimePicker({
    required this.time,
    required this.placeholder,
    required this.onTap,
  });

  final TimeOfDay? time;
  final String placeholder;
  final VoidCallback onTap;

  String get _label {
    if (time == null) return placeholder;
    final h = time!.hour.toString().padLeft(2, '0');
    final m = time!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: 18,
              color: time == null ? Colors.grey : Colors.blue.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              _label,
              style: TextStyle(
                fontSize: 14,
                color: time == null ? Colors.grey : Colors.black87,
                fontWeight: time != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
