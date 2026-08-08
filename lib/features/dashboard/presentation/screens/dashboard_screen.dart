import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/config/routes/router_app_shell_controls/shell_scroll_controller.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/bar/search_bar_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/header_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/cart/profile_row_cart.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/state_section.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:go_router/go_router.dart';
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _companyFetched = false;
  //////////////////////////////////////////////////////////////////////////////
  // ──Cache scroll controller here, not inside build() ──────────────
  //////////////////////////////////////////////////////////////////////////////
  ScrollController? _scrollController;
  ////////////////////////////////////////
  ///
  ////////////////////////////////////////
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController ??= ShellScrollController.of(context);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///  INITSTATE
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    ref.read(notificationNotifierProvider.notifier).loadMyNotifications();
    ref.listenManual(profileNotifierProvider, (_, next) {
      next.whenData((profile) {
        final companyId = profile.companyId;

        ////////////////////////
        ///
        /////////////////////////
        if (companyId > 0 && !_companyFetched) {
          _companyFetched = true;
          ref.read(companyProvider.notifier).fetchCompany(companyId).then((_) {
            final hasError =
                ref.read(companyProvider).valueOrNull?.error != null;
            if (hasError) _companyFetched = false;
          });
        }
        ////////////////////////
        ///
        ///////////////////////
      });
    }, fireImmediately: true);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
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

    ////////////////////////////////////////
    ///
    ////////////////////////////////////////
    final logoUrl = ref.watch(
      companyProvider.select((s) => s.valueOrNull?.company?.logoUrl),
    );
    ////////////////////////////////////////
    ///
    ////////////////////////////////////////
    final companyId = ref.watch(
      profileNotifierProvider.select((s) => s.valueOrNull?.companyId ?? 0),
    );
    ////////////////////////////////////////
    ///
    ////////////////////////////////////////
    final unreadCount = ref.watch(
      notificationNotifierProvider.select(
        (s) => s.valueOrNull?.summary?.unread ?? 0,
      ),
    );
    final profileAsync = ref.watch(profileNotifierProvider);
    ////////////////////////////////////////
    ///
    ////////////////////////////////////////
    final screenWidth = MediaQuery.sizeOf(context).width;
    final hPad = screenWidth * 0.045;
    final bottomPad = MediaQuery.of(context).padding.bottom + 62 + 16;
    final topPad = MediaQuery.of(context).padding.top + 16;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Pallets.backgroundDark
          : Pallets.backgroundLight,
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
            ////////////////////////////////////////////////////////////////////
            ///  HEADER WIDGETS
            ////////////////////////////////////////////////////////////////////
            HeaderWidget(
              companyName: companyName,
              logoUrl: logoUrl,
              //////////////////////////////////////////////////////////////////
              //
              //////////////////////////////////////////////////////////////////
              onCompanyTap: () {
                context.push('/companies/$companyId');
              },
              onNotificationTap: () {
                context.push(RouteNames.notifications);
              },
              unreadCount: unreadCount,
            ),
            ////////////////////////////////////////////////////////////////////
            ///  SEARCHING
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 16),
            SearchAppBar(hint: 'Search modules, settings...'),
            ////////////////////////////////////////////////////////////////////
            /// PROFILEROWS
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 16),
            ProfileRow(profileAsync: profileAsync),
            ////////////////////////////////////////////////////////////////////
            ///STATESECTION
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 20),
            ModulesSection(screenWidth: screenWidth, currentUser: currentUser),
            ////////////////////////////////////////////////////////////////////
            /// ATTENDANCESECTION
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 24),
            const AttendanceSection(),
            ////////////////////////////////////////////////////////////////////
            /// RECENTACTIVITYSECTION
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 20),
            const RecentActivitySection(),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
