import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_notifier.dart'
    hide AttendanceSettings;
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/office_qr_dialog.dart';

Future<void> refreshOfficeQr(WidgetRef ref) {
  return ref.read(scanAttendanceProvider.notifier).fetchOfficeQr();
}

void showOfficeQrDialog(BuildContext context, WidgetRef ref) {
  final qrData = ref.read(scanAttendanceProvider).value?.officeQr;
  showDialog(
    context: context,
    builder: (ctx) => OfficeQrDialog(
      token: qrData?['qr_token']?.toString(),
      expiresAt: qrData?['expires_at']?.toString(),
      onRefresh: () async {
        Navigator.pop(ctx);
        await refreshOfficeQr(ref);
      },
    ),
  );
}
