import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/data/models/models.dart';

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

Widget buildStatsGrid(double screenWidth) {
  final cellWidth = (screenWidth - screenWidth * 0.09 - 14) / 2;
  final cellHeight = cellWidth * 0.75;

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
      // ── FIX: Isolated StatefulWidget so the animation runs once on
      //   first mount and never replays on parent rebuilds. ────────────
      return _StatCard(stat: stats[index], delay: index * 100);
    },
  );
}

// Stateful so the AnimationController is owned here and fires only once.
class _StatCard extends StatefulWidget {
  final DashboardStat stat;
  final int delay; // milliseconds

  const _StatCard({required this.stat, required this.delay});

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

    // Delay each card so they stagger in on first load only.
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
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Pallets.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Pallets.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: stat.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(stat.icon, color: stat.color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.title,
                  style: const TextStyle(
                    color: Pallets.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
