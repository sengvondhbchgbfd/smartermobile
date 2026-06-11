import 'package:flutter/material.dart';
import 'staff_dashboard_screen.dart';
import 'manager_dashboard_screen.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});
  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
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
        title: const Text('Leave Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'My Leaves'),
            Tab(icon: Icon(Icons.admin_panel_settings), text: 'Manager Portal'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [StaffDashboardScreen(), ManagerDashboardScreen()],
      ),
    );
  }
}
