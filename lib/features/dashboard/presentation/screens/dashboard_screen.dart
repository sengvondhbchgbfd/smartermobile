import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
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
          ),
        ],
      ),
    );
  }
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
