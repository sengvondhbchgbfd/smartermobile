import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import 'package:frontendmobile/features/hr/leave/presentation/screens/leave_detail_screen.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_card.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_empty.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/leave_form.dart';
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final card = isDark ? const Color(0xFF141418) : Colors.white;
    final border = isDark ? const Color(0xFF232329) : const Color(0xFFE8E8EF);
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    final textSecondary = isDark
        ? const Color(0xFF8B8B9A)
        : const Color(0xFF6B6B7A);

    const accent = Color(0xFF6366F1);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final asyncState = ref.watch(staffLeaveProvider);
    final notifier = ref.read(staffLeaveProvider.notifier);
    ref.listen(staffLeaveProvider, (prev, next) {
      final error = next.value?.error;
      if (error != null && error != prev?.value?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: notifier.clearError,
            ),
          ),
        );
      }
    });

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton.extended(
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        onPressed: () => Navigator.push(context, SubmitLeaveForm.route()),
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 0,
        label: const Text(
          'Apply Leave',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      ////////////////////////////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////////////////////////////
      body: asyncState.when(
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        loading: () => Center(child: CircularProgressIndicator(color: accent)),
        error: (e, _) => Center(
          child: Text('Error: $e', style: TextStyle(color: textSecondary)),
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        data: (state) {
          ////////////////////////////////////////////////////////////////////////
          ///
          ////////////////////////////////////////////////////////////////////////
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator(color: accent));
          }
          if (state.leaves.isEmpty) {
            return EmptyState(textSecondary: textSecondary, accent: accent);
          }
          ////////////////////////////////////////////////////////////////////////
          ///
          ////////////////////////////////////////////////////////////////////////

          return RefreshIndicator(
            color: accent,
            backgroundColor: card,
            onRefresh: () => notifier.fetchMyLeaves(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: state.leaves.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final leave = state.leaves[index];
                final days = leaveDays(leave.startDate, leave.endDate);

                return LeaveCard(
                  leave: leave,
                  days: days,
                  card: card,
                  border: border,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  accent: accent,
                  showCountdown: true,
                  fmtDate: leaveDateFmt,
                  onTap: () => Navigator.push(
                    context,
                    LeaveDetailScreen.fromEntity(leave),
                  ),
                  trailing: leave.status == LeaveStatus.pending
                      ? GestureDetector(
                          onTap: () => notifier.cancelLeave(leave.leaveId),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFF59E0B).withOpacity(0.3),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFFF59E0B),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
