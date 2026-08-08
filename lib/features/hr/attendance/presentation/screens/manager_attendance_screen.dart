import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_export_helper.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_filter_helpers.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/core/utils/staff_profile_helper.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/attendance_settings_sheet.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/export_bottom_sheet.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/managers/records_list.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/managers/search_field.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/manual_correction_dialog.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/office_qr_helper.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/remind_dialog.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff_profile_sheet.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import '../providers/attendance_notifier.dart' hide AttendanceSettings;
import '../../domain/entities/attendance_entity.dart';
import '../widgets/attendance_stats_row.dart';
import '../widgets/attendance_month_header.dart';

class ManagerAttendanceScreen extends ConsumerStatefulWidget {
  const ManagerAttendanceScreen({super.key});

  @override
  ConsumerState<ManagerAttendanceScreen> createState() =>
      _ManagerAttendanceScreenState();
}

class _ManagerAttendanceScreenState
    extends ConsumerState<ManagerAttendanceScreen> {
  late int _month;
  late int _year;
  String? _filterDate;
  String? _rangeStart;
  String? _rangeEnd;
  int? _filterStaffId;
  final _searchController = TextEditingController();
  bool _showSearch = false;

  // ── Lifecycle ───────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _registerListeners();
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Listeners ───────────────────────────────────────────────────────────────

  void _registerListeners() {
    ref.listenManual(managerAttendanceProvider, (prev, next) {
      if (!mounted) return;
      final error = next.value?.error;
      if (error != null && error != prev?.value?.error) {
        _showErrorSnackBar(
          error,
          ref.read(managerAttendanceProvider.notifier).clearError,
        );
      }
    });

    ref.listenManual(scanAttendanceProvider, (prev, next) {
      if (!mounted) return;
      final error = next.value?.error;
      if (error != null && error != prev?.value?.error) {
        _showErrorSnackBar(
          error,
          ref.read(scanAttendanceProvider.notifier).clearError,
        );
      }
    });
  }

  // ── Data loading ────────────────────────────────────────────────────────────

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    final n = ref.read(managerAttendanceProvider.notifier);
    await Future.wait([
      n.fetchTodaySummary(),
      n.fetchAllAttendance(),
      ref.read(scanAttendanceProvider.notifier).fetchOfficeQr(),
    ]);
  }

  // ── Month navigation ────────────────────────────────────────────────────────

  void _changeMonth(int delta) {
    if (!mounted) return;
    setState(() {
      _month += delta;
      if (_month > 12) {
        _month = 1;
        _year++;
      } else if (_month < 1) {
        _month = 12;
        _year--;
      }
    });
    ref
        .read(managerAttendanceProvider.notifier)
        .fetchAllAttendance(
          filterDate: _filterDate,
          month: _month,
          year: _year,
        );
  }

  // ── Filters ─────────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _filterDate = fmtDate(picked);
      _rangeStart = null;
      _rangeEnd = null;
      _filterStaffId = null;
      _showSearch = false;
      _searchController.clear();
    });
    ref
        .read(managerAttendanceProvider.notifier)
        .fetchAllAttendance(filterDate: _filterDate);
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: (_rangeStart != null && _rangeEnd != null)
          ? DateTimeRange(
              start: DateTime.parse(_rangeStart!),
              end: DateTime.parse(_rangeEnd!),
            )
          : null,
    );
    if (range == null || !mounted) return;
    setState(() {
      _rangeStart = fmtDate(range.start);
      _rangeEnd = fmtDate(range.end);
      _filterDate = null;
      _filterStaffId = null;
      _showSearch = false;
      _searchController.clear();
    });
    ref
        .read(managerAttendanceProvider.notifier)
        .fetchByDateRange(startDate: _rangeStart!, endDate: _rangeEnd!);
  }

  void _clearFilter() {
    setState(() {
      _filterDate = null;
      _rangeStart = null;
      _rangeEnd = null;
      _filterStaffId = null;
      _showSearch = false;
      _searchController.clear();
    });
    ref.read(managerAttendanceProvider.notifier).fetchAllAttendance();
  }

  void _fetchByStaff(String raw) {
    final id = int.tryParse(raw.trim());
    if (id == null || !mounted) return;
    setState(() => _filterStaffId = id);
    ref
        .read(managerAttendanceProvider.notifier)
        .fetchAllAttendance(staffId: id);
  }

  // ── Record actions ──────────────────────────────────────────────────────────

  void _onRecordTap(AttendanceEntity record) {
    _showStaffProfile(record);
    ref.read(managerAttendanceProvider.notifier).fetchById(record.attendanceId);
  }

  Future<void> _onRecordLongPress(AttendanceEntity record) async {
    final result = await ManualCorrectionDialog.show(context, record);
    if (result == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Correction saved for #${record.attendanceId} · ${result.reason}',
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
    ref
        .read(managerAttendanceProvider.notifier)
        .fetchAllAttendance(filterDate: _filterDate);
  }

  // ── Staff profile ───────────────────────────────────────────────────────────

  void _showStaffProfile(AttendanceEntity record) {
    final allRecords = ref.read(managerAttendanceProvider).value?.records ?? [];
    final settings = ref.read(attendanceSettingsProvider).settings;
    final leaves = ref.read(staffLeaveProvider).value?.leaves ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StaffProfileSheet(
        profile: buildStaffProfile(
          record: record,
          allRecords: allRecords,
          settings: settings,
          leaves: leaves,
        ),
      ),
    );
  }

  // ── Export ──────────────────────────────────────────────────────────────────

  void _openExport() {
    ExportBottomSheet.show(
      context,
      onExport: (req) async {
        if (!mounted) return;
        await ref
            .read(managerAttendanceProvider.notifier)
            .fetchByDateRange(
              startDate: DateFormatter.fmtApi(req.startDate),
              endDate: DateFormatter.fmtApi(req.endDate),
            );
        if (!mounted) return;
        final records =
            ref.read(managerAttendanceProvider).value?.records ?? [];
        if (records.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No records found for the selected range.'),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
        final dateRange =
            '${DateFormatter.fmt(req.startDate)} - ${DateFormatter.fmt(req.endDate)}';
        final filename =
            'attendance_${DateFormatter.fmtApi(req.startDate)}_${DateFormatter.fmtApi(req.endDate)}';
        final bytes = req.format == ExportFormat.csv
            ? AttendanceExportHelper.toCsv(records)
            : await AttendanceExportHelper.toPdf(
                records,
                title: 'Attendance Report',
                dateRange: dateRange,
              );
        if (!mounted) return;
        await AttendanceExportHelper.share(
          bytes,
          format: req.format,
          filename: filename,
          context: context,
        );
        if (mounted) {
          ref
              .read(managerAttendanceProvider.notifier)
              .fetchAllAttendance(filterDate: _filterDate);
        }
      },
    );
  }

  // ── Remind ──────────────────────────────────────────────────────────────────

  // Future<void> _openRemind() async {
  //   await ref
  //       .read(managerAttendanceProvider.notifier)
  //       .fetchAllAttendance(filterDate: fmtDate(DateTime.now()));
  //   if (!mounted) return;
  //   final records = ref.read(managerAttendanceProvider).value?.records ?? [];
  //   final unchecked = records
  //       .where((r) => r.checkInTime == null || r.checkInTime!.isEmpty)
  //       .map(
  //         (r) => StaffRemindItem(
  //           id: r.staffId,
  //           name: r.displayName,
  //           department: r.staffName,
  //           photoUrl: r.staffAvatarUrl,
  //         ),
  //       )
  //       .toList();
  //   if (!mounted) return;
  //   await RemindDialog.show(
  //     context,
  //     uncheckedStaff: unchecked,
  //     onSendReminder: (staffUserIds) async {
  //       if (staffUserIds.isEmpty) return;
  //       final notifier = ref.read(notificationNotifierProvider.notifier);
  //       try {
  //         await Future.wait(
  //           staffUserIds.map(
  //             (userId) => notifier.adminCreate(
  //               userId: userId,
  //               title: 'Attendance reminder',
  //               message:
  //                   "You haven't checked in yet today. Please check in now.",
  //               type: 'warning',
  //             ),
  //           ),
  //         );
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(
  //                 'Reminder sent to ${staffUserIds.length} staff member${staffUserIds.length == 1 ? '' : 's'}.',
  //               ),
  //               backgroundColor: Colors.green.shade700,
  //               behavior: SnackBarBehavior.floating,
  //             ),
  //           );
  //         }
  //       } catch (e) {
  //         if (mounted)
  //           _showErrorSnackBar('Failed to send reminders: $e', () {});
  //       }
  //     },
  //   );
  //   if (mounted) {
  //     ref
  //         .read(managerAttendanceProvider.notifier)
  //         .fetchAllAttendance(
  //           filterDate: _filterDate,
  //           month: _month,
  //           year: _year,
  //         );
  //   }
  // }

  // ── Settings ────────────────────────────────────────────────────────────────

  // Future<void> _openSettings() async {
  //   if (!mounted) return;
  //   final notifier = ref.read(attendanceSettingsProvider.notifier);
  //   await notifier.fetchSettings();
  //   if (!mounted) return;
  //   final s = ref.read(attendanceSettingsProvider);
  //   if (s.settings == null) {
  //     _showSaveResult(s.error ?? 'Failed to load settings');
  //     return;
  //   }
  //   final formData = AttendanceSettings(
  //     officeLat: s.settings!.officeLatitude,
  //     officeLng: s.settings!.officeLongitude,
  //     geofenceRadius: s.settings!.allowedRadiusMeters,
  //     lateThresholdMinutes: s.settings!.lateThresholdMinutes,
  //     overtimeThresholdMinutes: s.settings!.overtimeThresholdMinutes,
  //     officeOpenTime: s.settings!.officeOpenTime,
  //     officeCloseTime: s.settings!.officeCloseTime,
  //     timezone: s.settings!.timezone,
  //     departments: const [],
  //   );
  //   await AttendanceSettingsSheet.show(
  //     context,
  //     initial: formData,
  //     onSave: (newSettings) async {
  //       await notifier.updateSettings(
  //         officeLatitude: newSettings.officeLat,
  //         officeLongitude: newSettings.officeLng,
  //         allowedRadiusMeters: newSettings.geofenceRadius,
  //         lateThresholdMinutes: newSettings.lateThresholdMinutes,
  //         overtimeThresholdMinutes: newSettings.overtimeThresholdMinutes,
  //         officeOpenTime: newSettings.officeOpenTime,
  //         officeCloseTime: newSettings.officeCloseTime,
  //         timezone: newSettings.timezone,
  //       );
  //       if (!mounted) return;
  //       _showSaveResult(ref.read(attendanceSettingsProvider).error);
  //     },
  //     onShowQr: () => showOfficeQrDialog(context, ref),
  //     onRefreshQr: () => refreshOfficeQr(ref),
  //   );
  // }

  // ── Snackbars ───────────────────────────────────────────────────────────────

  void _showErrorSnackBar(String message, VoidCallback onDismiss) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: onDismiss,
        ),
      ),
    );
  }

  // void _showSaveResult(String? error) {
  //   if (!mounted) return;
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     error != null
  //         ? SnackBar(
  //             content: Text(error),
  //             backgroundColor: Colors.red,
  //             behavior: SnackBarBehavior.floating,
  //           )
  //         : const SnackBar(
  //             content: Text('✅ Settings saved'),
  //             backgroundColor: Colors.green,
  //             behavior: SnackBarBehavior.floating,
  //           ),
  //   );
  // }

  // ── Computed ────────────────────────────────────────────────────────────────

  String get _filterLabel => buildFilterLabel(
    filterDate: _filterDate,
    rangeStart: _rangeStart,
    rangeEnd: _rangeEnd,
    filterStaffId: _filterStaffId,
  );

  bool get _hasFilter => hasActiveFilter(
    filterDate: _filterDate,
    rangeStart: _rangeStart,
    filterStaffId: _filterStaffId,
  );

  // ── Build ───────────────────────────────────────────────────────────────────
  //
  // STYLE: minimal flat — no box shadows, no boxed card borders. Sections
  // are separated by generous whitespace and (where truly needed) a single
  // hairline divider instead of a bordered container. Accent color is used
  // sparingly, only where it carries meaning (active filter, loading, links).

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dividerColor = isDark ? Pallets.dividerDark : Pallets.dividerLight;

    final asyncState = ref.watch(managerAttendanceProvider);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: asyncState.when(
          loading: () => Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Pallets.gradient2,
            ),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Pallets.error,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$e',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: _loadInitialData,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Retry'),
                    style: TextButton.styleFrom(
                      foregroundColor: Pallets.gradient2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (state) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Today's stats ─────────────────────────────────────
              if (state.todaySummary.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: AttendanceStatsRow(stats: state.todaySummary),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Divider(height: 1, thickness: 1, color: dividerColor),
                ),
              ],

              // ── Month header ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: AttendanceMonthHeader.manager(
                  month: _month,
                  year: _year,
                  onPrevious: () => _changeMonth(-1),
                  onNext: () => _changeMonth(1),
                  onReport: _openExport,
                  filterLabel: _filterLabel,
                  hasFilter: _hasFilter,
                  showSearch: _showSearch,
                  onPickDate: _pickDate,
                  onPickDateRange: _pickDateRange,
                  onToggleSearch: () =>
                      setState(() => _showSearch = !_showSearch),
                  onClearFilter: _clearFilter,
                ),
              ),

              // ── Search field ──────────────────────────────────────
              if (_showSearch)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: StaffSearchField(
                    controller: _searchController,
                    onSubmit: _fetchByStaff,
                    onClear: () {
                      _searchController.clear();
                      setState(() {
                        _filterStaffId = null;
                        _showSearch = false;
                      });
                      ref
                          .read(managerAttendanceProvider.notifier)
                          .fetchAllAttendance();
                    },
                  ),
                ),

              // ── Active filter (plain text link, not a chip) ───────
              if (_hasFilter)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: GestureDetector(
                    onTap: _clearFilter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_alt_outlined,
                          size: 14,
                          color: Pallets.gradient2,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _filterLabel,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Pallets.gradient2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: Pallets.gradient2.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 1, thickness: 1, color: dividerColor),
              ),

              // ── Records list ──────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: RecordsList(
                    isLoading: state.isLoading,
                    records: state.records,
                    selectedId: state.selected?.attendanceId,
                    onTap: _onRecordTap,
                    onLongPress: _onRecordLongPress,
                    onRefresh: () => ref
                        .read(managerAttendanceProvider.notifier)
                        .fetchAllAttendance(filterDate: _filterDate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
