import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import 'package:frontendmobile/features/hr/leave/presentation/screens/leave_detail_screen.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_action_row.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_card.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_empty.dart'
    show EmptyState;
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_filter_chip.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_summary_card_import.dart';
import 'package:intl/intl.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
class ManagerDashboardScreen extends ConsumerStatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  ConsumerState<ManagerDashboardScreen> createState() =>
      _ManagerDashboardScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _ManagerDashboardScreenState
    extends ConsumerState<ManagerDashboardScreen> {
  bool _showOnlyPending = true;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(managerLeaveProvider.notifier).fetchLeaveSummary();
      _loadLeaves();
    });
  }

  void _loadLeaves() {
    if (_showOnlyPending) {
      ref.read(managerLeaveProvider.notifier).fetchPendingLeaves();
    } else {
      ref.read(managerLeaveProvider.notifier).fetchAllLeaves();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  String _fmt(DateTime d) => DateFormat('dd MMM yyyy').format(d);
  int _days(DateTime start, DateTime end) => end.difference(start).inDays + 1;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF4F4F8);
    final card = isDark ? const Color(0xFF141418) : Colors.white;
    final border = isDark ? const Color(0xFF232329) : const Color(0xFFE8E8EF);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F0F14);
    final textSecondary = isDark
        ? const Color(0xFF8B8B9A)
        : const Color(0xFF6B6B7A);
    const accent = Color(0xFF6366F1);
    final asyncState = ref.watch(managerLeaveProvider);
    final notifier = ref.read(managerLeaveProvider.notifier);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      body: asyncState.when(
        loading: () => Center(child: CircularProgressIndicator(color: accent)),
        error: (e, _) => Center(
          child: Text('Error: $e', style: TextStyle(color: textSecondary)),
        ),
        data: (state) => RefreshIndicator(
          color: accent,
          backgroundColor: card,
          onRefresh: () async => _loadLeaves(),
          child: CustomScrollView(
            slivers: [
              //////////////////////////////////////////////////////////////////
              // ── Summary ────────────────────────────────────────────────
              //////////////////////////////////////////////////////////////////
              if (state.summary != null && state.summary!.isNotEmpty)
                SliverToBoxAdapter(
                  child: LeaveSummaryCardImport(summary: state.summary!),
                ),

              //////////////////////////////////////////////////////////////////
              // ── Filter row ─────────────────────────────────────────────
              //////////////////////////////////////////////////////////////////
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Row(
                    children: [
                      Text(
                        _showOnlyPending ? 'Pending Requests' : 'All Requests',
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      FilterChips(
                        label: 'Pending only',
                        selected: _showOnlyPending,
                        accent: accent,
                        textSecondary: textSecondary,
                        border: border,
                        card: card,
                        onTap: () {
                          setState(() => _showOnlyPending = !_showOnlyPending);
                          _loadLeaves();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              //////////////////////////////////////////////////////////////////
              // ── List ───────────────────────────────────────────────────
              //////////////////////////////////////////////////////////////////
              if (state.isLoading)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: accent),
                  ),
                )
              else if (state.leaves.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    textSecondary: textSecondary,
                    accent: accent,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final leave = state.leaves[index];
                      final days = _days(leave.startDate, leave.endDate);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: LeaveCard(
                          leave: leave,
                          days: days,
                          card: card,
                          border: border,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          accent: accent,
                          showCountdown: true,
                          fmtDate: _fmt,
                          onTap: () => Navigator.push(
                            context,
                            LeaveDetailScreen.fromEntity(leave),
                          ),
                          trailing: leave.status == LeaveStatus.pending
                              ? ActionRow(
                                  onApprove: () =>
                                      notifier.approveLeave(leave.leaveId),
                                  onReject: () => notifier.rejectLeave(
                                    leave.leaveId,
                                    reason: 'Rejected by Manager',
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      notifier.deleteLeave(leave.leaveId),
                                ),
                        ),
                      );
                    }, childCount: state.leaves.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
