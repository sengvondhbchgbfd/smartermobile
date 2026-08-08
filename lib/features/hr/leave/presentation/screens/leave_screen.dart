import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'staff_dashboard_screen.dart';
import 'manager_dashboard_screen.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});
  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  void _ensureTabController() {
    _tabController ??= TabController(length: 2, vsync: this);
  }

  void _disposeTabController() {
    _tabController?.dispose();
    _tabController = null;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    final hasStaffRecord = currentUser?.staffId != null;
    final canManage =
        (currentUser?.canApproveLeave ?? false) ||
        (currentUser?.canViewTeamLeave ?? false);

    final showBothTabs = hasStaffRecord && canManage;
    final showManagerOnly = canManage && !hasStaffRecord;

    if (showBothTabs) {
      _ensureTabController();
    } else {
      _disposeTabController();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        bottom: !showBothTabs
            ? null
            : TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.person), text: 'My Leaves'),
                  Tab(
                    icon: Icon(Icons.admin_panel_settings),
                    text: 'Manager Portal',
                  ),
                ],
              ),
      ),
      body: showBothTabs
          ? TabBarView(
              controller: _tabController,
              children: const [
                StaffDashboardScreen(),
                ManagerDashboardScreen(),
              ],
            )
          : showManagerOnly
              ? const ManagerDashboardScreen()
              : const StaffDashboardScreen(),
    );
  }
}