import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/shell_scroll_controller.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/department_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/role_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/user_tabs.dart';
import 'package:go_router/go_router.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});
  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _UserScreenState extends ConsumerState<UserScreen>
    with SingleTickerProviderStateMixin {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  late TabController _tabController;
  bool _fabVisible = true;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _checkPagination() {
    final controller = ShellScrollController.of(context);
    if (controller == null || !controller.hasClients) return;
    final position = controller.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      final state = ref.read(userNotifierProvider).valueOrNull;
      if (state != null && state.hasMoreUsers && !state.isLoadingMore) {
        ref.read(userNotifierProvider.notifier).loadMore();
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _onFabPressed() {
    switch (_tabController.index) {
      case 0:
        context.push('/users/create-user');
        break;
      case 1:
        context.push('/users/create-role');
        break;
      case 2:
        context.push('/users/create-department');
        break;
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      final direction = notification.direction;
      if (direction == ScrollDirection.reverse && _fabVisible) {
        setState(() => _fabVisible = false);
      } else if (direction == ScrollDirection.forward && !_fabVisible) {
        setState(() => _fabVisible = true);
      }
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final iconBg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.05);

    final asyncState = ref.watch(userNotifierProvider);
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        ////////////////////////////////////////////////////////////////////////
        /// APPBAR
        ////////////////////////////////////////////////////////////////////////
        leading: GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(
              Icons.chevron_left_rounded,
              color: textPrimary,
              size: 22,
            ),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        /// APPBAR
        ////////////////////////////////////////////////////////////////////////
        title: Text(
          'User Management',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        /// APPBAR
        ////////////////////////////////////////////////////////////////////////
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallets.blurple,
          labelColor: Pallets.blurple,
          unselectedLabelColor: textSecondary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(icon: Icon(Icons.person_outline_rounded), text: 'Users'),
            Tab(icon: Icon(Icons.badge_outlined), text: 'Roles'),
            Tab(icon: Icon(Icons.business_outlined), text: 'Departments'),
          ],
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScrollNotification(notification);
          _checkPagination();
          return false;
        },
        child: asyncState.when(
          loading: () =>
              Center(child: CircularProgressIndicator(color: Pallets.blurple)),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Pallets.errorTint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Pallets.error,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    style: TextStyle(color: textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(userNotifierProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.blurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          data: (data) => TabBarView(
            controller: _tabController,
            children: [
              UserTabs(data: data),
              RolesTab(data: data),
              DepartmentTab(data: data),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        offset: _fabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _fabVisible ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: Pallets.brandGradient,
                boxShadow: [
                  BoxShadow(
                    color: Pallets.blurple.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: Pallets.transparent,
                elevation: 0,
                onPressed: _fabVisible ? _onFabPressed : null,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
