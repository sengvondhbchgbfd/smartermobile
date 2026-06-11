import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/attendance_auth_helper.dart';
import 'package:frontendmobile/core/utils/attendance_dialogs.dart';
import 'package:frontendmobile/core/utils/attendance_token_session.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_state.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/attendance_scann_sheet.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/check_in_out_row.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/show_error.dart';
import '../providers/attendance_notifier.dart';
import '../widgets/attendance_month_header.dart';
import '../widgets/attendance_record_tile.dart';
import '../widgets/attendance_stats_row.dart';

class StaffAttendanceScreen extends ConsumerStatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  ConsumerState<StaffAttendanceScreen> createState() =>
      _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends ConsumerState<StaffAttendanceScreen> {
  late int _month;
  late int _year;
  ProviderSubscription<AsyncValue<StaffAttendanceState>>? _staffSub;
  ProviderSubscription<AsyncValue<ScanAttendanceState>>? _scanSub;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _staffSub = ref.listenManual(staffAttendanceProvider, (prev, next) {
        if (!mounted) return;
        final error = next.value?.error;
        if (error != null && error != prev?.value?.error) {
          AttendanceErrorMessage.show(
            context,
            message: error,
            onDismiss: ref.read(staffAttendanceProvider.notifier).clearError,
          );
        }
      });

      _scanSub = ref.listenManual(scanAttendanceProvider, (prev, next) {
        if (!mounted) return;
        final error = next.value?.error;
        if (error != null && error != prev?.value?.error) {
          AttendanceErrorMessage.show(
            context,
            message: error,
            onDismiss: ref.read(scanAttendanceProvider.notifier).clearError,
          );
        }
      });
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _staffSub?.close();
    _scanSub?.close();
    super.dispose();
  }

  // ── Data loading ───────────────────────────────────────────────────────────

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    final staffState = ref.read(staffAttendanceProvider).value;
    final scanState = ref.read(scanAttendanceProvider).value;
    final alreadyLoaded =
        staffState != null &&
        staffState.records.isNotEmpty &&
        staffState.monthlyStats.isNotEmpty &&
        scanState?.officeQr != null;
    if (alreadyLoaded) return;
    await Future.wait([
      if (staffState == null || staffState.records.isEmpty)
        ref
            .read(staffAttendanceProvider.notifier)
            .fetchMyAttendance(month: _month, year: _year),
      if (staffState == null || staffState.monthlyStats.isEmpty)
        ref
            .read(staffAttendanceProvider.notifier)
            .fetchMonthlyStats(month: _month, year: _year),
      if (scanState?.officeQr == null)
        ref.read(scanAttendanceProvider.notifier).fetchOfficeQr(),
    ]);
  }

  Future<void> _refreshRecords() async {
    if (!mounted) return;
    await ref
        .read(staffAttendanceProvider.notifier)
        .fetchMyAttendance(month: _month, year: _year);
  }

  // ── Month navigation ───────────────────────────────────────────────────────

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
    if (!mounted) return;
    final notifier = ref.read(staffAttendanceProvider.notifier);
    notifier.fetchMyAttendance(month: _month, year: _year);
    notifier.fetchMonthlyStats(month: _month, year: _year);
  }

  // ── Core: auth-gate → scan sheet ──────────────────────────────────────────

  Future<void> _handleAttendance({required bool isCheckIn}) async {
    if (!mounted) return;

    final user = ref.read(currentUserProvider);
    if (user == null) {
      AttendanceDialogs.showError(
        context,
        'Session expired. Please log in again.',
      );
      return;
    }
    final hasSession = await AttendanceAuthHelper.ensureValidSession(
      context: context,
      isMounted: () => mounted,
      isSessionValid: () => AttendanceTokenSession.instance.isValid,
      onAuthenticate: (password) async {
        if (!mounted) return;
        await ref
            .read(scanAttendanceProvider.notifier)
            .authenticate(password: password);
        if (!mounted) return;
        final scanState = ref.read(scanAttendanceProvider).value;
        if (scanState?.error != null) return;
        AttendanceAuthHelper.extractAndPersistTokens(
          context: context,
          scanState: scanState,
        );
      },
    );
    ///////////////////////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////////////////////

    if (!hasSession || !mounted) return;
    final success = await AttendanceScanSheet.show(
      context: context,
      isCheckIn: isCheckIn,
      companyId: user.companyId.toString(),
    );

    if (!mounted) return;
    if (success == true) {
      await _refreshRecords();
    }
  }
  ///////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(staffAttendanceProvider);
    final isScanLoading =
        ref.watch(scanAttendanceProvider).value?.isLoading ?? false;
    return Scaffold(
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (state) => Column(
            children: [
              ////////////////////////////////////////////////////////////////
              ///
              ////////////////////////////////////////////////////////////////
              CheckInOutRow(
                isLoading: isScanLoading,
                onCheckIn: () => _handleAttendance(isCheckIn: true),
                onCheckOut: () => _handleAttendance(isCheckIn: false),
              ),

              //////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////
              AttendanceMonthHeader.staff(
                month: _month,
                year: _year,
                onPrevious: () => _changeMonth(-1),
                onNext: () => _changeMonth(1),
              ),
              //////////////////////////////////////////////////////////////
              ///
              ///////////////////////////////////////////////////////////////
              if (state.monthlyStats.isNotEmpty)
                AttendanceStatsRow(stats: state.monthlyStats),
              const SizedBox(height: 8),
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.records.isEmpty
                    ? const Center(child: Text('No attendance records found.'))
                    : RefreshIndicator(
                        onRefresh: _refreshRecords,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: state.records.length,
                          itemBuilder: (_, i) =>
                              AttendanceRecordTile(record: state.records[i]),
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
