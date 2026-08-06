import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/staff_attendance_screen.dart';
import 'package:go_router/go_router.dart';
import 'manager_attendance_screen.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});
  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////
  TabController? _tabController;
  void _ensureTabController() {
    _tabController ??= TabController(length: 2, vsync: this);
  }
  ////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final iconBg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.07);
    final iconColor = isDark ? Colors.white : Pallets.textPrimaryLight;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final currentUser = ref.watch(currentUserProvider);
    final isManagerOrAdmin = currentUser?.canViewTeamAttendance ?? false;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (isManagerOrAdmin) {
      _ensureTabController();
    } else {
      _tabController?.dispose();
      _tabController = null;
    }
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bgColor,

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(Icons.chevron_left_rounded, color: iconColor, size: 22),
          ),
        ),
        title: Text(
          'Attendance',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: !isManagerOrAdmin
            ? null
            : TabBar(
                controller: _tabController,
                indicatorColor: Pallets.gradient2,
                labelColor: Pallets.gradient2,
                unselectedLabelColor: textSecondary,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.person_outline_rounded),
                    text: 'My Attendance',
                  ),
                  Tab(
                    icon: Icon(Icons.admin_panel_settings_outlined),
                    text: 'Manager View',
                  ),
                ],
              ),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: isManagerOrAdmin
          ? TabBarView(
              controller: _tabController,
              children: const [
                StaffAttendanceScreen(),
                ManagerAttendanceScreen(),
              ],
            )
          : const StaffAttendanceScreen(),
    );
  }
}
