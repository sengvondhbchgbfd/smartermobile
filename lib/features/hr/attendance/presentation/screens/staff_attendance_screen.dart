import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_state.dart';
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

  //////////////////////////////////////////////////////////////////////////////
  // ── Lifecycle ──────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

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

      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _staffSub?.close();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── Data loading ───────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    final staffState = ref.read(staffAttendanceProvider).value;
    final alreadyLoaded =
        staffState != null &&
        staffState.records.isNotEmpty &&
        staffState.monthlyStats.isNotEmpty;



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
    ]);
  }

  Future<void> _refreshRecords() async {
    if (!mounted) return;
    await ref
        .read(staffAttendanceProvider.notifier)
        .fetchMyAttendance(month: _month, year: _year);
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── Month navigation ───────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

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

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(staffAttendanceProvider);
    return Scaffold(
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (state) => Column(
            children: [
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

              //////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////
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
