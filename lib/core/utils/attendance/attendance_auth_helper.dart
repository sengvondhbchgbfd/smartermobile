import 'package:flutter/material.dart';
import 'package:frontendmobile/core/utils/scann/password_dialog.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_token_session.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_state.dart';

enum SessionAuthResult { success, cancelled, failed }

class AttendanceAuthHelper {
  const AttendanceAuthHelper._();

  // ── Main gate ──────────────────────────────────────────────────────────────
  static Future<SessionAuthResult> ensureValidSession({
    required BuildContext context,
    required Future<String?> Function(String password) onAuthenticate,
    required bool Function() isSessionValid,
    required bool Function() isMounted,
  }) async {
    if (isSessionValid()) return SessionAuthResult.success;

    if (!context.mounted || !isMounted()) return SessionAuthResult.cancelled;

    final confirmed = await _showPasswordDialog(context, onAuthenticate);
    if (confirmed == null) return SessionAuthResult.cancelled;
    if (confirmed == false) return SessionAuthResult.cancelled;

    if (!context.mounted || !isMounted()) return SessionAuthResult.cancelled;

    return isSessionValid()
        ? SessionAuthResult.success
        : SessionAuthResult.failed;
  }
  //////////////////////////////////////////////////////////////////////////////
  // ── Token extraction & persistence ────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  static bool extractAndPersistTokens({
    required BuildContext context,
    required ScanAttendanceState? scanState,
    bool requireOfficeQr = false,
  }) {
    final scanToken = scanState?.scanResult?['scan_token'] as String?;
    final officeQrToken = scanState?.officeQr?['qr_token'] as String?;

    final missingRequired =
        scanToken == null || (requireOfficeQr && officeQrToken == null);

    if (missingRequired) {
      return false;
    }
    AttendanceTokenSession.instance.save(
      scanToken: scanToken,
      officeQrToken: officeQrToken,
    );
    return true;
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── Password dialog ────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  static Future<bool?> _showPasswordDialog(
    BuildContext context,
    Future<String?> Function(String password) onSubmit,
  ) async {
    if (!context.mounted) return null;
    try {
      return await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 350),

        pageBuilder: (ctx, animation, secondaryAnimation) {
          return PasswordDialog(onSubmit: onSubmit);
        },

        transitionBuilder: (ctx, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      );
    } catch (_) {
      return null;
    }
  }
}
