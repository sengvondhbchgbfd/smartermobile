import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/staff_attendance_screen.dart';
import 'manager_attendance_screen.dart';
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}
class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'My Attendance'),
            Tab(icon: Icon(Icons.admin_panel_settings), text: 'Manager View'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [StaffAttendanceScreen(), ManagerAttendanceScreen()],
      ),
    );
  }
}
