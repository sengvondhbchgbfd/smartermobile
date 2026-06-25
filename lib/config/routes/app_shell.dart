import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:go_router/go_router.dart';

const List<(String, IconData, String)> _navItems = [
  (RouteNames.dashboard, Icons.dashboard_rounded, 'Home'),
  (RouteNames.attendance, Icons.qr_code_scanner_rounded, 'Scan'),
  (RouteNames.chat, Icons.chat_rounded, 'Chat'),
  (RouteNames.users, Icons.people_alt_rounded, 'Users'),
];

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  final ScrollController scrollController = ScrollController();
  double _lastOffset = 0;
  bool _isVisible = true;
  static const double _kNavBarHeight = 62;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 210),
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = scrollController.offset;
    final delta = offset - _lastOffset;
    if (delta > 6 && _isVisible) {
      _isVisible = false;
      _animController.forward();
    } else if (delta < -6 && !_isVisible) {
      _isVisible = true;
      _animController.reverse();
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  int _currentIndex(String location) {
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].$1)) return i;
    }
    return 0; // default to dashboard
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surfaceColor = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(location);

    return Scaffold(
      backgroundColor: bgColor, // ← theme-aware
      extendBody: true,
      body: ShellScrollController(
        controller: scrollController,
        child: widget.child,
      ),
      bottomNavigationBar: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Fade gradient ─────────────────────────────────────────
            IgnorePointer(
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      bgColor, // ← theme-aware
                    ],
                  ),
                ),
              ),
            ),

            // ── Nav bar ───────────────────────────────────────────────
            SizedBox(
              height: _kNavBarHeight,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: surfaceColor, // ← theme-aware
                selectedItemColor: Pallets.gradient2, // ← use brand color
                unselectedItemColor: textSecondary, // ← theme-aware
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                iconSize: 22,
                onTap: (index) {
                  if (currentIndex == index) return;
                  if (!_isVisible) {
                    _isVisible = true;
                    _animController.reverse();
                  }
                  Future.microtask(() => context.go(_navItems[index].$1));
                },
                items: _navItems
                    .map(
                      (d) => BottomNavigationBarItem(
                        icon: Icon(d.$2),
                        label: d.$3,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// ── InheritedWidget ───────────────────────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class ShellScrollController extends InheritedWidget {
  final ScrollController controller;

  const ShellScrollController({
    super.key,
    required this.controller,
    required super.child,
  });

  static ScrollController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ShellScrollController>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(ShellScrollController oldWidget) =>
      controller != oldWidget.controller;
}
