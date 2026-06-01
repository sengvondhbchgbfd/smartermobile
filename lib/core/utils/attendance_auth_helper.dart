import 'package:flutter/material.dart';
import 'package:frontendmobile/core/components/password_dialog.dart';
import 'package:frontendmobile/core/utils/attendance_token_session.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_state.dart';

class AttendanceAuthHelper {
  const AttendanceAuthHelper._();

  // ── Main gate ──────────────────────────────────────────────────────────────

  static Future<bool> ensureValidSession({
    required BuildContext context,
    required Future<void> Function(String password) onAuthenticate,
    required bool Function() isSessionValid,
    required bool Function() isMounted,
  }) async {
    if (isSessionValid()) return true;

    if (!context.mounted || !isMounted()) return false;

    final password = await _showPasswordDialog(context);
    if (password == null || password.isEmpty) return false;

    if (!context.mounted || !isMounted()) return false;

    await onAuthenticate(password);

    if (!context.mounted || !isMounted()) return false;

    return isSessionValid();
  }

  // ── Token extraction & persistence ────────────────────────────────────────

  static bool extractAndPersistTokens({
    required BuildContext context,
    required ScanAttendanceState? scanState,
  }) {
    final scanToken = scanState?.scanResult?['scan_token'] as String?;
    final officeQrToken = scanState?.officeQr?['qr_token'] as String?;

    if (scanToken == null || officeQrToken == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication succeeded but tokens are missing.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }

    AttendanceTokenSession.instance.save(
      scanToken: scanToken,
      officeQrToken: officeQrToken,
    );
    return true;
  }

  // ── Password dialog ────────────────────────────────────────────────────────

  static Future<String?> _showPasswordDialog(BuildContext context) async {
    if (!context.mounted) return null;
    try {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PasswordDialog(),
      );
    } catch (_) {
      return null;
    }
  }
}
