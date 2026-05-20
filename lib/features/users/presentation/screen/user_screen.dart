import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:frontendmobile/features/users/presentation/widgets/department_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/roles_tab.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_dialogs.dart';
import 'package:frontendmobile/features/users/presentation/widgets/user_tabs.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});
  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

////////////////////////////////////////////
///
///////////////////////////////////////////

class _UserScreenState extends ConsumerState<UserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  /////////////////////////////////
  ///
  ////////////////////////////////
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        break;
    }
  }

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
      ),
    );
  }
}
