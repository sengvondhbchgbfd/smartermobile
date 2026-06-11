import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:frontendmobile/features/hr/attendance/presentation/screens/staff_attendance_screen.dart';
import 'manager_attendance_screen.dart';
// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});
//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }
// class _AttendanceScreenState extends State<AttendanceScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();

//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(icon: Icon(Icons.person), text: 'My Attendance'),
//             Tab(icon: Icon(Icons.admin_panel_settings), text: 'Manager View'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: const [StaffAttendanceScreen(), ManagerAttendanceScreen()],
//       ),
//     );
//   }
// }
=======
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/staff_attendance_screen.dart';
import 'package:go_router/go_router.dart';
import 'manager_attendance_screen.dart';

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

<<<<<<< HEAD
// Simple color palette used by this screen. Defined here to avoid an
// undefined reference to `Pallets`.
class Pallets {
  static const Color backgroundDark = Color(0xFF0F1720);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color borderDark = Color(0xFF1F2937);
  static const Color gradient2 = Color(0xFF3B82F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
}

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
<<<<<<< HEAD
    _tabController.addListener(() => setState(() {}));
=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
<<<<<<< HEAD
      body: SafeArea(
        child: Column(
          children: [
            // Minimalist Header Navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Row(
                children: [
                  _buildGhostTab(0, 'Attendance'),
                  const SizedBox(width: 32),
                  _buildGhostTab(1, 'Management'),
                ],
              ),
            ),

            Expanded(
              child: IndexedStack(
                index: _tabController.index,
                children: const [
                  StaffAttendanceScreen(),
                  ManagerAttendanceScreen(),
                ],
              ),
=======
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
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
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallets.gradient2,
          labelColor: Pallets.gradient2,
          unselectedLabelColor: Pallets.textSecondaryDark,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(
              icon: Icon(Icons.person_outline_rounded),
              text: 'My Attendance',
            ),
            Tab(
              icon: Icon(Icons.admin_panel_settings_outlined),
              text: 'Manager View',
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
            ),
          ],
        ),
      ),
<<<<<<< HEAD
    );
  }

  Widget _buildGhostTab(int index, String title) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () => setState(() => _tabController.index = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Pallets.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 6),
          // A simple underline that only appears when active
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSelected ? 30 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: Pallets.gradient2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
=======
      body: TabBarView(
        controller: _tabController,
        children: const [StaffAttendanceScreen(), ManagerAttendanceScreen()],
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      ),
    );
  }
}
