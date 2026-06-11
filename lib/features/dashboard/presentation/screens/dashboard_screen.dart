import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:fl_chart/fl_chart.dart';

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
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/attendance_scann.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/chat_preview_widget.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/header_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/modules_grid_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/profile_row_cart.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/recent_activity_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/stage_grid_widgets.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:frontendmobile/config/routes/app_shell.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _companyFetched = false;
  //////////////////////////////////////////////////////////////////////////////
  // ── FIX 1: Cache scroll controller here, not inside build() ──────────────
  //////////////////////////////////////////////////////////////////////////////
  ScrollController? _scrollController;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController ??= ShellScrollController.of(context);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD

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
        const SizedBox(height: 24),
        _buildActivityGraph(), // <--- Add this here
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
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Pallets.surfaceDark.withOpacity(0.5),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    ),
    child: Row(
      children: [
        // User Profile/Avatar with status indicator
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Pallets.gradient2, width: 2)),
              child: const CircleAvatar(radius: 24, backgroundColor: Pallets.surfaceDark, child: Text('JD')),
            ),
            Positioned(right: 0, bottom: 0, child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.fromBorderSide(BorderSide(color: Pallets.backgroundDark, width: 2))))),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Good Morning, John', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Main Branch • ${DateTime.now().year}', style: const TextStyle(color: Pallets.textSecondaryDark, fontSize: 12)),
          ],
        ),
        const Spacer(),
        // Notification Pill
        Badge(
          label: const Text('3'),
          child: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: Colors.white)),
        ),
      ],
    ),
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
=======
    Future.microtask(() {
      ref.read(notificationNotifierProvider.notifier).loadMyNotifications();
      ref.listenManual(profileNotifierProvider, (_, next) {
        next.whenData((profile) {
          final companyId = profile.companyId;
          if (companyId > 0 && !_companyFetched) {
            _companyFetched = true;
            ref.read(companyProvider.notifier).fetchCompany(companyId);
          }
        });
      }, fireImmediately: true);
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final companyName = ref.watch(
      companyProvider.select(
        (s) => s.valueOrNull?.company?.companyName ?? 'Loading...',
      ),
    );
    final logoUrl = ref.watch(
      companyProvider.select((s) => s.valueOrNull?.company?.logoUrl),
    );
    final companyId = ref.watch(
      profileNotifierProvider.select((s) => s.valueOrNull?.companyId ?? 0),
    );
    final unreadCount = ref.watch(
      notificationNotifierProvider.select(
        (s) => s.valueOrNull?.summary?.unread ?? 0,
      ),
    );

    final profileAsync = ref.watch(profileNotifierProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hPad = screenWidth * 0.045;
    final bottomPad = MediaQuery.of(context).padding.bottom + 62 + 16;
    final topPad = MediaQuery.of(context).padding.top + 16;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBody: true,
      body: SingleChildScrollView(
        ////////////////////////////////////////////////////////////////////////
        // ── FIX 1: Use cached controller ─────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(hPad, topPad, hPad, bottomPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              companyName: companyName,
              logoUrl: logoUrl,
              //////////////////////////////////////////////////////////////////
              // ── FIX 3: microtask lets the tap ripple finish before push ────
              //////////////////////////////////////////////////////////////////
              onCompanyTap: () =>
                  Future.microtask(() => context.push('/companies/$companyId')),
              onNotificationTap: () => Future.microtask(
                () => context.push(RouteNames.notifications),
              ),
              unreadCount: unreadCount,
            ),

            const SizedBox(height: 16),
            const _SearchBar(),
            const SizedBox(height: 16),
            ProfileRow(profileAsync: profileAsync),
            const SizedBox(height: 20),
            _StatsSection(screenWidth: screenWidth),
            const SizedBox(height: 24),
            _ModulesSection(screenWidth: screenWidth),
            const SizedBox(height: 24),
            const _AttendanceSection(),
            const SizedBox(height: 20),
            const _ChatPreviewSection(),
            const SizedBox(height: 20),
            const _RecentActivitySection(),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(52, 51, 67, 1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Color(0xFFA7A7A7), size: 20),
          SizedBox(width: 10),
          Text(
            'Search modules...',
            style: TextStyle(color: Color(0xFFA7A7A7), fontSize: 14),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD

  // ─────────────────────────────────────────────
  // USER CONTROLLER
  // ─────────────────────────────────────────────

Widget _buildUserControllerCard() {
  return Container(
    padding: const EdgeInsets.all(2), // Padding for the border glow effect
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Pallets.gradient1, Pallets.gradient3]),
      borderRadius: BorderRadius.circular(26),
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Pallets.surfaceDark, // Deep background
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Styled Avatar with subtle glow
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Pallets.gradient2.withOpacity(0.2),
              child: Text(
                currentUser.avatar,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentUser.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Pallets.gradient1.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text(currentUser.role, style: TextStyle(color: Pallets.gradient1, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Text(currentUser.branch, style: const TextStyle(color: Pallets.textSecondaryDark, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          // Action Button
          Material(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_note_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
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
      const Text('System Modules', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
      const SizedBox(height: 16),
      GridView.builder(
        shrinkWrap: true,
        itemCount: modules.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final module = modules[index];
          // Wrapping in Material allows for the ripple effect (touchable feel)
          return Material(
            color: Pallets.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => print("${module.title} tapped"), // Add navigation here
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(module.icon, color: module.color, size: 32),
                    const Spacer(),
                    Text(module.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text(module.subtitle, style: const TextStyle(color: Pallets.textSecondaryDark, fontSize: 11)),
                  ],
                ),
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
      border: Border.all(color: Pallets.borderDark.withOpacity(0.5)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.green, size: 28),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Check-in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('QR & Face Scan', style: TextStyle(color: Pallets.textSecondaryDark, fontSize: 12)),
            ],
          ),
        ),
        // Professional Touch-friendly Button
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.camera_alt, size: 16),
          label: const Text('Scan'),
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


Widget _buildActivityGraph() {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Pallets.surfaceDark,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Pallets.borderDark),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('System Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 3), FlSpot(1, 1), FlSpot(2, 4), 
                    FlSpot(3, 2), FlSpot(4, 5), FlSpot(5, 3),
                  ],
                  isCurved: true,
                  color: Pallets.gradient2,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true, 
                    color: Pallets.gradient2.withOpacity(0.2)
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
=======
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) => buildStatsGrid(screenWidth);
}

class _ModulesSection extends StatelessWidget {
  const _ModulesSection({required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) => buildModules(screenWidth);
}

class _AttendanceSection extends StatelessWidget {
  const _AttendanceSection();

  @override
  Widget build(BuildContext context) => buildAttendanceCard();
}

class _ChatPreviewSection extends StatelessWidget {
  const _ChatPreviewSection();

  @override
  Widget build(BuildContext context) => buildChatPreview();
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context) => buildRecentActivity();
}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
