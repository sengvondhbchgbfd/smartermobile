import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_form.dart';
import '../widgets/leave_status_badge.dart';

class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
  /////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////
  void _showSubmitLeaveBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SubmitLeaveForm(),
    );
  }
  /////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(staffLeaveProvider);
    final notifier = ref.read(staffLeaveProvider.notifier);

    ref.listen(staffLeaveProvider, (prev, next) {
      final error = next.value?.error;
      if (error != null && error != prev?.value?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () => notifier.clearError(),
            ),
          ),
        );
      }
    });

    /////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSubmitLeaveBottomSheet,
        label: const Text('Apply Leave'),
        icon: const Icon(Icons.add),
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.leaves.isEmpty) {
            return const Center(child: Text('No leave applications found.'));
          }
          return RefreshIndicator(
            onRefresh: () => notifier.fetchMyLeaves(),
            child: ListView.builder(
              itemCount: state.leaves.length,
              itemBuilder: (context, index) {
                final leave = state.leaves[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  child: ListTile(
                    title: Text('${leave.leaveType.name.toUpperCase()} Leave'),
                    subtitle: Text(
                      '${_fmt(leave.startDate)} to ${_fmt(leave.endDate)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LeaveStatusBadge(status: leave.status),
                        if (leave.status == LeaveStatus.pending)
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.amber),
                            onPressed: () =>
                                notifier.cancelLeave(leave.leaveId),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _fmt(DateTime d) => d.toLocal().toString().split(' ')[0];
}
