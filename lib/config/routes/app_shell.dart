import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/constance.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/floating_navbar.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/shell_scroll_controller.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_auth_helper.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_dialogs.dart';
import 'package:frontendmobile/core/utils/attendance/attendance_token_session.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_notifier.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/attendance_scann_sheet.dart';
import 'package:go_router/go_router.dart';

//////////////////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////////////////
class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  final String? avatarUrl;
  const AppShell({super.key, required this.child, this.avatarUrl});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}
/////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {
  ////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  final ScrollController scrollController = ScrollController();
  double _lastOffset = 0;
  bool _isVisible = true;
  bool _isScanBusy = false;
  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.6)).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Curves.easeInOutCubic,
          ),
        );
    scrollController.addListener(_onScroll);
  }
  
  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

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

  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

  int _currentIndex(String location) {
    for (int i = 0; i < navItems.length; i++) {
      if (navItems[i].$1 == '__scan__') continue;
      if (location.startsWith(navItems[i].$1)) return i;
    }
    return 0;
  }

  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

  void _onTap(int index, int currentIndex) {
    if (navItems[index].$1 == '__scan__') {
      _openScanDirectly();
      return;
    }
    if (currentIndex == index) return;
    if (!_isVisible) {
      _isVisible = true;
      _animController.reverse();
    }
    Future.microtask(() => context.go(navItems[index].$1));
  }

  //////////////////////////////////////////////////////////////////////////////
  ///  OPEN SCAN DIRECTLY
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _openScanDirectly() async {
    if (_isScanBusy || !mounted) return;
    setState(() => _isScanBusy = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        if (!mounted) return;
        AttendanceDialogs.showError(
          context,
          'Session expired. Please log in again.',
        );
        return;
      }

      //////////////////////////////////////////////////////////////////////////
      ///
      ///
      ///
      //////////////////////////////////////////////////////////////////////////

      final result = await AttendanceAuthHelper.ensureValidSession(
        context: context,
        isMounted: () => mounted,
        isSessionValid: () => AttendanceTokenSession.instance.isValid,
        onAuthenticate: (password) async {
          await ref
              .read(scanAttendanceProvider.notifier)
              .authenticate(password: password);

          if (!mounted) return 'Something went wrong. Please try again.';

          final scanState = ref.read(scanAttendanceProvider).value;
          if (scanState?.error != null) {
            return scanState!.error.toString();
          }

          final ok = AttendanceAuthHelper.extractAndPersistTokens(
            context: context,
            scanState: scanState,
          );
          if (!ok) {
            return 'Authentication succeeded but tokens are missing.';
          }
          return null;
        },
      );

      //////////////////////////////////////////////////////////////////////////
      /// SESSION CHECK RESULT
      //////////////////////////////////////////////////////////////////////////

      switch (result) {
        case SessionAuthResult.success:
          if (!mounted) return;
          await AttendanceScanSheet.show(
            context: context,
            companyId: user.companyId.toString(),
          );
          return;
        case SessionAuthResult.cancelled:
          return;
        case SessionAuthResult.failed:
          if (mounted) {
            AttendanceDialogs.showError(
              context,
              'Authentication failed. Please try again.',
            );
          }
      }
    } finally {
      if (mounted) setState(() => _isScanBusy = false);
    }
  }

  /////////////////////////////////////////////////////////////////
  ///  WIDGET BUILD
  ////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _currentIndex(location);
    ////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      body: ShellScrollController(
        controller: scrollController,
        child: widget.child,
      ),
      bottomNavigationBar: SlideTransition(
        position: _slideAnimation,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 14, left: 16, right: 16),
          child: FloatingNavBar(
            isDark: isDark,
            currentIndex: currentIndex,
            avatarUrl: widget.avatarUrl,
            onTap: (i) => _onTap(i, currentIndex),
          ),
        ),
      ),
    );
  }
}
