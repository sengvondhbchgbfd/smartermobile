import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/distane_indicator.dart';

class AttendanceDialogs {
  const AttendanceDialogs._();

  // ── 403 / business-rule error ──────────────────────────────────────────────

  /// Shows the "Cannot Check In/Out" dialog with an optional distance bar.
  static void showAttendanceError(
    BuildContext context,
    Map<String, dynamic> detail,
  ) {
    final message = detail['message'] as String? ?? 'Action not allowed.';
    final hint = detail['hint'] as String?;
    final distanceRaw = detail['distance_meters'];
    final allowedRadius = detail['allowed_radius'];

    final body = hint != null ? '$message\n\n$hint' : message;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.location_off, color: Colors.red.shade600),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Cannot Check In/Out',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(body, style: const TextStyle(fontSize: 14)),
            if (distanceRaw != null && allowedRadius != null) ...[
              const SizedBox(height: 16),
              DistanceIndicator(
                distanceMeters: (distanceRaw as num).toDouble(),
                allowedRadius: (allowedRadius as num).toDouble(),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── Generic snack-bar helpers ──────────────────────────────────────────────

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}