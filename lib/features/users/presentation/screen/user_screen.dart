import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/department_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/roles_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_dialogs.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_tabs.dart';
=======
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/department_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/role_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/user_tabs.dart';
import 'package:go_router/go_router.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});
  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

<<<<<<< HEAD
////////////////////////////////////////////
///
///////////////////////////////////////////
=======
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

class _UserScreenState extends ConsumerState<UserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
<<<<<<< HEAD

=======
  bool _fabVisible = true;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

<<<<<<< HEAD
  /////////////////////////////////
  ///
  ////////////////////////////////
=======
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
<<<<<<< HEAD

  ///////////////////////////
  ///
  ///////////////////////////
  void _onFabPressed() {
    final state = ref.read(userNotifierProvider).valueOrNull;
    switch (_tabController.index) {
      case 0:
        showCreateUserDialog(context, ref, state);
        break;
      case 1:
        showCreateRoleDialog(context, ref);
        break;
      case 2:
        showCreateDepartmentDialog(context, ref, state);
=======
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
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
        break;
    }
  }

<<<<<<< HEAD
  /////////////////////////////////
  ///
  ///////////////////////////////
  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(userNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: "Users"),
            Tab(icon: Icon(Icons.badge), text: "Roles"),
            Tab(icon: Icon(Icons.business), text: "Departments"),
          ],
        ),
      ),

      ////////////////////////////////
      ///
      ///////////////////////////////
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (data) => TabBarView(
          controller: _tabController,
          children: [
            UserTabs(data: data),
            RolesTab(data: data),
            DepartmentTab(data: data),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
=======
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
    final asyncState = ref.watch(userNotifierProvider);
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.backgroundDark,
        elevation: 0,
        centerTitle: false,
        ////////////////////////////////////////////////////////////////////////
        ///
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
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        title: const Text(
          'User Management',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallets.gradient2,
          labelColor: Pallets.gradient2,
          unselectedLabelColor: Pallets.textSecondaryDark,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(icon: Icon(Icons.person_outline_rounded), text: 'Users'),
            Tab(icon: Icon(Icons.badge_outlined), text: 'Roles'),
            Tab(icon: Icon(Icons.business_outlined), text: 'Departments'),
          ],
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      /// Body wrapped in NotificationListener for scroll detection
      //////////////////////////////////////////////////////////////////////////
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScrollNotification(notification);
          return false;
        },
        child: asyncState.when(
          loading: () => Center(
            child: CircularProgressIndicator(color: Pallets.gradient2),
          ),
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
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    style: TextStyle(
                      color: Pallets.textSecondaryDark,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(userNotifierProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.gradient2,
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

      //////////////////////////////////////////////////////////////////////////
      /// FAB — above bottom nav + animated show/hide on scroll
      //////////////////////////////////////////////////////////////////////////
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        offset: _fabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _fabVisible ? 1.0 : 0.0,
          child: Padding(
            // ✅ lifts FAB above bottom nav bar
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton(
              backgroundColor: Pallets.gradient2,
              onPressed: _fabVisible ? _onFabPressed : null,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      ),
    );
  }
}
