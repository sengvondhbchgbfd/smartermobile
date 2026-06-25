import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_notifier.dart'hide AttendanceSettings;
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/attendance_settings_sheet.dart';
import 'package:go_router/go_router.dart';

class AttendanceSettingsPage extends ConsumerStatefulWidget {
  const AttendanceSettingsPage({super.key});

  @override
  ConsumerState<AttendanceSettingsPage> createState() =>
      _AttendanceSettingsPageState();
}


////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

class _AttendanceSettingsPageState
    extends ConsumerState<AttendanceSettingsPage> {
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    await ref.read(attendanceSettingsProvider.notifier).fetchSettings();
    if (mounted) setState(() => _loading = false);
  }

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

  Future<void> _save(AttendanceSettings s) async {
    setState(() => _saving = true);
    await ref
        .read(attendanceSettingsProvider.notifier)
        .updateSettings(
          officeLatitude: s.officeLat,
          officeLongitude: s.officeLng,
          allowedRadiusMeters: s.geofenceRadius,
          lateThresholdMinutes: s.lateThresholdMinutes,
          overtimeThresholdMinutes: s.overtimeThresholdMinutes,
          officeOpenTime: s.officeOpenTime,
          officeCloseTime: s.officeCloseTime,
          timezone: s.timezone,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    final err = ref.read(attendanceSettingsProvider).error;
    if (err != null) {
      setState(() => _error = err);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Attendance settings saved'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    final s = ref.watch(attendanceSettingsProvider);
    final settings = s.settings;

    if (_loading) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: CircularProgressIndicator(color: Pallets.gradient2),
        ),
      );
    }

    if (settings == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: textSecondary),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Pallets.error, size: 40),
              const SizedBox(height: 12),
              Text(
                _error ?? 'Failed to load settings',
                style: TextStyle(color: textSecondary),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _load,
                style: FilledButton.styleFrom(
                  backgroundColor: Pallets.gradient2,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }


////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////


    return AttendanceSettingsSheet(
      initial: AttendanceSettings(
        officeLat: settings.officeLatitude,
        officeLng: settings.officeLongitude,
        geofenceRadius: settings.allowedRadiusMeters,
        lateThresholdMinutes: settings.lateThresholdMinutes,
        overtimeThresholdMinutes: settings.overtimeThresholdMinutes,
        officeOpenTime: settings.officeOpenTime,
        officeCloseTime: settings.officeCloseTime,
        timezone: settings.timezone,
        departments: const [],
      ),
      onSave: _save,
      asPage: true,
    );
  }
}
