import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import '../widgets/leave_status_badge.dart';
import '../widgets/leave_summary_card.dart';

class ManagerDashboardScreen extends ConsumerStatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  ConsumerState<ManagerDashboardScreen> createState() =>
      _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState
    extends ConsumerState<ManagerDashboardScreen> {
  bool _showOnlyPending = true;

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

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(managerLeaveProvider);
    final notifier = ref.read(managerLeaveProvider.notifier);

    return Scaffold(
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (state) => Column(
          children: [
            if (state.summary != null && state.summary!.isNotEmpty)
              LeaveSummaryCard(summary: state.summary!),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showOnlyPending
                        ? 'Pending Requests'
                        : 'All Requests History',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  FilterChip(
                    label: const Text('Only Pending'),
                    selected: _showOnlyPending,
                    onSelected: (val) {
                      setState(() => _showOnlyPending = val);
                      _loadLeaves();
                    },
                  ),
                ],
              ),
            ),

            // 2. Main List
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.leaves.isEmpty
                  ? const Center(child: Text('No requests match filters.'))
                  : ListView.builder(
                      itemCount: state.leaves.length,
                      itemBuilder: (context, index) {
                        final leave = state.leaves[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: ExpansionTile(
                            title: Text(
                              '${leave.displayName} · ${leave.leaveType.name.toUpperCase()}',
                            ),
                            subtitle: Text(
                              '${_fmt(leave.startDate)} to ${_fmt(leave.endDate)}',
                            ),
                            leading: LeaveStatusBadge(status: leave.status),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reason: ${leave.reason ?? "No reason specified"}',
                                    ),
                                    const SizedBox(height: 12),
                                    if (leave.status == LeaveStatus.pending)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                notifier.rejectLeave(
                                                  leave.leaveId,
                                                  reason: 'Rejected by Manager',
                                                ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                            child: const Text('Reject'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () => notifier
                                                .approveLeave(leave.leaveId),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text('Approve'),
                                          ),
                                        ],
                                      )
                                    else
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () => notifier.deleteLeave(
                                            leave.leaveId,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => d.toLocal().toString().split(' ')[0];
}
