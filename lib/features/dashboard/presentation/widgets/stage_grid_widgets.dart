import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/dashboard/data/models/models.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_notifier.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_providers.dart';
import 'package:go_router/go_router.dart';

class StatsGrid extends ConsumerStatefulWidget {
  const StatsGrid({super.key});
  @override
  ConsumerState<StatsGrid> createState() => _StatsGridState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _StatsGridState extends ConsumerState<StatsGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentUser = ref.read(currentUserProvider);
      if (currentUser?.canViewTeamAttendance ?? false) {
        ref.read(managerAttendanceProvider.notifier).fetchTodaySummary();
      }
      ref.read(invoiceNotifierProvider.notifier).loadAll();
    });
  }

  void _onStatTapped(BuildContext context, String title) {
    switch (title) {
      case 'Employees':
        context.push('/employees');
        break;
      case 'Attendance':
        context.push('/attendance');
        break;
      case 'Messages':
        context.push('/messages');
        break;
      case 'Invoices':
        context.push('/invoices');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cellWidth = (screenWidth - screenWidth * 0.09 - 14) / 2;
    final cellHeight = cellWidth * 0.75;
    final currentUser = ref.watch(currentUserProvider);
    final canViewTeam = currentUser?.canViewTeamAttendance ?? false;
    // ── Attendance / Employees (manager/admin only) ──────────────────────────
    String totalEmployeesValue = '—';
    String attendanceValue = '—';

    if (canViewTeam) {
      final managerAsync = ref.watch(managerAttendanceProvider);
      final attendanceLoading = managerAsync.isLoading;
      final summary = managerAsync.value?.todaySummary;

      final totalEmployees =
          summary?['total_employees'] ?? summary?['totalEmployees'];
      final presentCount =
          summary?['present_count'] ?? summary?['presentCount'];

      totalEmployeesValue = attendanceLoading && summary == null
          ? '...'
          : (totalEmployees?.toString() ?? '0');

      attendanceValue = attendanceLoading && summary == null
          ? '...'
          : (totalEmployees != null &&
                    totalEmployees > 0 &&
                    presentCount != null
                ? '${((presentCount / totalEmployees) * 100).toStringAsFixed(0)}%'
                : '0%');
    }

    // ── Invoices ─────────────────────────────────────────────────────────────

    final invoiceState = ref.watch(invoiceNotifierProvider);
    final invoiceCount = invoiceState.invoices.length;
    final invoicesValue =
        invoiceState.isLoading && invoiceState.invoices.isEmpty
        ? '...'
        : _formatCount(invoiceCount);

    final stats = <DashboardStat>[
      if (canViewTeam) ...[
        DashboardStat(
          title: 'Employees',
          value: totalEmployeesValue,
          icon: Icons.people_alt_rounded,
          color: Colors.blue,
        ),
        DashboardStat(
          title: 'Attendance',
          value: attendanceValue,
          icon: Icons.qr_code_scanner_rounded,
          color: Colors.green,
        ),
      ],
      const DashboardStat(
        title: 'Messages',
        value: '16',
        icon: Icons.chat_bubble_rounded,
        color: Colors.purple,
      ),
      DashboardStat(
        title: 'Invoices',
        value: invoicesValue,
        icon: Icons.receipt_long_rounded,
        color: Colors.orange,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: stats.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: cellWidth / cellHeight,
      ),
      itemBuilder: (context, index) {
        return _StatCard(
          stat: stats[index],
          delay: index * 100,
          onTap: () => _onStatTapped(context, stats[index].title),
        );
      },
    );
  }

  String _formatCount(int count) {
    final str = count.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i != 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

class _StatCard extends StatefulWidget {
  final DashboardStat stat;
  final int delay;
  final VoidCallback? onTap;

  const _StatCard({required this.stat, required this.delay, this.onTap});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stat = widget.stat;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Pallets.borderDark : Pallets.borderLight,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(isDark ? 0.15 : 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.value,
                      style: TextStyle(
                        color: isDark
                            ? Pallets.textPrimaryDark
                            : Pallets.textPrimaryLight,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat.title,
                      style: TextStyle(
                        color: isDark
                            ? Pallets.textSecondaryDark
                            : Pallets.textSecondaryLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
