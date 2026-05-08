import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// PALETTE
// ─────────────────────────────────────────────

class Pallets {
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E2E);

  static const Color borderDark = Color.fromRGBO(52, 51, 67, 1);

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFA7A7A7);

  static const Color success = Colors.green;
  static const Color error = Colors.redAccent;
}

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class DashboardModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const DashboardModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class UserController {
  final String name;
  final String role;
  final String branch;
  final String avatar;

  const UserController({
    required this.name,
    required this.role,
    required this.branch,
    required this.avatar,
  });
}

// ─────────────────────────────────────────────
// DASHBOARD
// ─────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  int selectedBottomIndex = 0;

  // ─────────────────────────────────────────────
  // USER
  // ─────────────────────────────────────────────

  final UserController currentUser = const UserController(
    name: 'John Doe',
    role: 'Administrator',
    branch: 'Main Branch',
    avatar: 'JD',
  );

  // ─────────────────────────────────────────────
  // STATS
  // ─────────────────────────────────────────────

  final List<DashboardStat> stats = const [
    DashboardStat(
      title: 'Employees',
      value: '48',
      icon: Icons.people_alt_rounded,
      color: Colors.blue,
    ),
    DashboardStat(
      title: 'Attendance',
      value: '92%',
      icon: Icons.qr_code_scanner_rounded,
      color: Colors.green,
    ),
    DashboardStat(
      title: 'Messages',
      value: '16',
      icon: Icons.chat_bubble_rounded,
      color: Colors.purple,
    ),
    DashboardStat(
      title: 'Invoices',
      value: '1,284',
      icon: Icons.receipt_long_rounded,
      color: Colors.orange,
    ),
  ];

  // ─────────────────────────────────────────────
  // MODULES
  // ─────────────────────────────────────────────

  final List<DashboardModule> modules = const [
    DashboardModule(
      title: 'User Control',
      subtitle: 'Roles & Permissions',
      icon: Icons.admin_panel_settings_rounded,
      color: Colors.indigo,
    ),
    DashboardModule(
      title: 'Attendance Scan',
      subtitle: 'QR & Face Scan',
      icon: Icons.qr_code_scanner_rounded,
      color: Colors.green,
    ),
    DashboardModule(
      title: 'Chat System',
      subtitle: 'DM & Groups',
      icon: Icons.chat_rounded,
      color: Colors.purple,
    ),
    DashboardModule(
      title: 'HR / Staff',
      subtitle: 'Employees',
      icon: Icons.people_alt_rounded,
      color: Colors.blue,
    ),
    DashboardModule(
      title: 'Inventory',
      subtitle: 'Products & Stock',
      icon: Icons.inventory_2_rounded,
      color: Colors.teal,
    ),
    DashboardModule(
      title: 'Invoices',
      subtitle: 'Billing System',
      icon: Icons.receipt_long_rounded,
      color: Colors.orange,
    ),
    DashboardModule(
      title: 'CRM',
      subtitle: 'Customers',
      icon: Icons.groups_rounded,
      color: Colors.red,
    ),
    DashboardModule(
      title: 'Payroll',
      subtitle: 'Salary & Bonus',
      icon: Icons.payments_rounded,
      color: Colors.amber,
    ),
  ];

  // ─────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallets.backgroundDark,

      bottomNavigationBar: _buildBottomNavigation(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallets.gradient2,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 24),

              _buildSearchBar(),

              const SizedBox(height: 24),

              _buildUserControllerCard(),

              const SizedBox(height: 24),

              _buildStatsGrid(),

              const SizedBox(height: 28),

              _buildModules(),

              const SizedBox(height: 28),

              _buildAttendanceCard(),

              const SizedBox(height: 24),

              _buildChatPreview(),

              const SizedBox(height: 24),

              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Pallets.gradient1, Pallets.gradient2, Pallets.gradient3],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.dashboard_rounded, color: Colors.white),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'BizCore ERP',
                style: TextStyle(
                  color: Pallets.textPrimaryDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Business Management System',
                style: TextStyle(
                  color: Pallets.textSecondaryDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Stack(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Pallets.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Pallets.borderDark),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SEARCH
  // ─────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Pallets.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Row(
        children: const [
          Icon(Icons.search_rounded, color: Pallets.textSecondaryDark),
          SizedBox(width: 10),
          Text(
            'Search modules...',
            style: TextStyle(color: Pallets.textSecondaryDark),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // USER CONTROLLER
  // ─────────────────────────────────────────────

  Widget _buildUserControllerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Pallets.gradient1, Pallets.gradient2],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              currentUser.avatar,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  currentUser.role,
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 4),

                Text(
                  currentUser.branch,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STATS
  // ─────────────────────────────────────────────

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: stats.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + (index * 120)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Pallets.surfaceDark,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Pallets.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(stat.icon, color: stat.color),
                ),

                const Spacer(),

                Text(
                  stat.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  stat.title,
                  style: const TextStyle(color: Pallets.textSecondaryDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // MODULES
  // ─────────────────────────────────────────────

  Widget _buildModules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Modules',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          itemCount: modules.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];

            return InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Pallets.surfaceDark,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Pallets.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: module.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(module.icon, color: module.color),
                    ),

                    const Spacer(),

                    Text(
                      module.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      module.subtitle,
                      style: const TextStyle(
                        color: Pallets.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // ATTENDANCE
  // ─────────────────────────────────────────────

  Widget _buildAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Pallets.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.green,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance Scanner',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  'QR Scan & Face Recognition',
                  style: TextStyle(color: Pallets.textSecondaryDark),
                ),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {},
            child: const Text('Scan'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CHAT
  // ─────────────────────────────────────────────

  Widget _buildChatPreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Pallets.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team Chat',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 18),

          _chatTile('Sarah', 'Please approve invoice #102', '2m'),

          _chatTile('Tom', 'Meeting at 3PM', '10m'),

          _chatTile('Maria', 'Payroll completed', '1h'),
        ],
      ),
    );
  }

  Widget _chatTile(String name, String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Pallets.gradient2,
            child: Text(name[0], style: const TextStyle(color: Colors.white)),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  message,
                  style: const TextStyle(color: Pallets.textSecondaryDark),
                ),
              ],
            ),
          ),

          Text(time, style: const TextStyle(color: Pallets.textSecondaryDark)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // RECENT ACTIVITY
  // ─────────────────────────────────────────────

  Widget _buildRecentActivity() {
    final items = [
      'Invoice created',
      'Attendance scanned',
      'User added',
      'Stock updated',
      'Payroll approved',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Pallets.surfaceDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Pallets.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 18),

          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(e, style: const TextStyle(color: Colors.white)),
                  ),

                  const Text(
                    'Now',
                    style: TextStyle(color: Pallets.textSecondaryDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAVIGATION
  // ─────────────────────────────────────────────

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: selectedBottomIndex,
      backgroundColor: Pallets.surfaceDark,
      selectedItemColor: Pallets.gradient2,
      unselectedItemColor: Pallets.textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          selectedBottomIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_scanner_rounded),
          label: 'Scan',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: 'Chat'),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}
