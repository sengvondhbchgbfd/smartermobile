import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// PALETTE
// ─────────────────────────────────────────────

class Pallets {
  // Brand Gradient
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);

  // Backgrounds
  static const Color backgroundDark = Color.fromRGBO(18, 18, 18, 1);
  static const Color backgroundLight = Color(0xFFF5F5F5);

  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Border
  static const Color borderDark = Color.fromRGBO(52, 51, 67, 1);
  static const Color borderLight = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimaryDark = Colors.white;
  static const Color textPrimaryLight = Color(0xFF121212);

  static const Color textSecondaryDark = Color(0xFFA7A7A7);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);

  // Semantic
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
  static const Color inactive = Color(0xFFABABAB);
  static const Color transparent = Colors.transparent;
  static const Color inactiveSeek = Colors.white38;
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

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  final List<DashboardModule> modules = const [
    DashboardModule(
      title: 'HR / Staff',
      subtitle: 'Employees & Roles',
      icon: Icons.people_alt_rounded,
      color: Colors.blue,
    ),
    DashboardModule(
      title: 'Invoices',
      subtitle: 'Billing & Payments',
      icon: Icons.receipt_long_rounded,
      color: Colors.orange,
    ),
    DashboardModule(
      title: 'Inventory',
      subtitle: 'Stock & Products',
      icon: Icons.inventory_2_rounded,
      color: Colors.green,
    ),
    DashboardModule(
      title: 'CRM',
      subtitle: 'Customers',
      icon: Icons.groups_rounded,
      color: Colors.red,
    ),
    DashboardModule(
      title: 'Chat',
      subtitle: 'Messages',
      icon: Icons.chat_bubble_rounded,
      color: Colors.purple,
    ),
    DashboardModule(
      title: 'Settings',
      subtitle: 'System Config',
      icon: Icons.settings_rounded,
      color: Colors.grey,
    ),
  ];

  final List<DashboardStat> stats = const [
    DashboardStat(
      title: 'Invoices',
      value: '1,284',
      icon: Icons.receipt_rounded,
      color: Colors.orange,
    ),
    DashboardStat(
      title: 'Employees',
      value: '48',
      icon: Icons.people_alt_rounded,
      color: Colors.blue,
    ),
    DashboardStat(
      title: 'Products',
      value: '932',
      icon: Icons.inventory_2_rounded,
      color: Colors.green,
    ),
    DashboardStat(
      title: 'Customers',
      value: '392',
      icon: Icons.groups_rounded,
      color: Colors.red,
    ),
  ];

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

  bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color bgColor(BuildContext context) {
    return isDark(context) ? Pallets.backgroundDark : Pallets.backgroundLight;
  }

  Color surfaceColor(BuildContext context) {
    return isDark(context) ? Pallets.surfaceDark : Pallets.surfaceLight;
  }

  Color borderColor(BuildContext context) {
    return isDark(context) ? Pallets.borderDark : Pallets.borderLight;
  }

  Color textPrimary(BuildContext context) {
    return isDark(context) ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
  }

  Color textSecondary(BuildContext context) {
    return isDark(context)
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),

              const SizedBox(height: 24),

              _buildHeader(context),

              const SizedBox(height: 24),

              _buildStatsGrid(context),

              const SizedBox(height: 28),

              _buildModules(context),

              const SizedBox(height: 28),

              _buildRecentActivity(context),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TOP BAR
  // ─────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Pallets.gradient1, Pallets.gradient2, Pallets.gradient3],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.dashboard_rounded, color: Colors.white),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BizCore',
                style: TextStyle(
                  color: textPrimary(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Business Dashboard',
                style: TextStyle(color: textSecondary(context), fontSize: 12),
              ),
            ],
          ),
        ),

        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: surfaceColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor(context)),
          ),
          child: Icon(
            Icons.notifications_rounded,
            color: textPrimary(context),
            size: 20,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Morning 👋',
            style: TextStyle(color: textSecondary(context), fontSize: 14),
          ),

          const SizedBox(height: 6),

          Text(
            'Main Dashboard',
            style: TextStyle(
              color: textPrimary(context),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STATS
  // ─────────────────────────────────────────────

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: stats.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: surfaceColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(stat.icon, color: stat.color),
                ),

                const Spacer(),

                Text(
                  stat.value,
                  style: TextStyle(
                    color: textPrimary(context),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  stat.title,
                  style: TextStyle(color: textSecondary(context), fontSize: 13),
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

  Widget _buildModules(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modules',
          style: TextStyle(
            color: textPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          itemCount: modules.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];

            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 500 + (index * 120)),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: surfaceColor(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor(context)),
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
                        style: TextStyle(
                          color: textPrimary(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        module.subtitle,
                        style: TextStyle(
                          color: textSecondary(context),
                          fontSize: 12,
                        ),
                      ),
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
  // RECENT ACTIVITY
  // ─────────────────────────────────────────────

  Widget _buildRecentActivity(BuildContext context) {
    final activities = [
      'Invoice #1002 created',
      'New employee added',
      'Stock updated',
      'Customer payment received',
      'Payroll completed',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              color: textPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 18),

          ...activities.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Pallets.gradient1, Pallets.gradient2],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: textPrimary(context),
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Text(
                    '2m ago',
                    style: TextStyle(
                      color: textSecondary(context),
                      fontSize: 12,
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
}
