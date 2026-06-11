import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:go_router/go_router.dart';

const List<(String, IconData, String)> _navItems = [
  (RouteNames.dashboard, Icons.dashboard_rounded, 'Home'),
  (RouteNames.attendance, Icons.qr_code_scanner_rounded, 'Scan'),
  (RouteNames.chat, Icons.chat_rounded, 'Chat'),
  (RouteNames.users, Icons.people_alt_rounded, 'Users'),
  (RouteNames.settings, Icons.settings_rounded, 'Settings'),
];

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

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
      duration: const Duration(milliseconds: 220),
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
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(location);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
            // Fade gradient so content dissolves into the nav bar
            IgnorePointer(
              child: Container(
                height: 24,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xFF121212)],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: _kNavBarHeight,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                backgroundColor: const Color(0xFF1E1E2E),
                selectedItemColor: const Color.fromRGBO(251, 109, 169, 1),
                unselectedItemColor: const Color(0xFFA7A7A7),
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

// ── InheritedWidget — passes scroll controller to shell screens only ──────────

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
