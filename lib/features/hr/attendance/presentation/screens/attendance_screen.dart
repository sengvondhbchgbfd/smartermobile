import 'package:flutter/material.dart';
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
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

// Simple color palette used by this screen. Defined here to avoid an
// undefined reference to `Pallets`.
class Pallets {
  static const Color backgroundDark = Color(0xFF0F1720);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color borderDark = Color(0xFF1F2937);
  static const Color gradient2 = Color(0xFF3B82F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
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
            ),
          ],
        ),
      ),
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
      ),
    );
  }
}
