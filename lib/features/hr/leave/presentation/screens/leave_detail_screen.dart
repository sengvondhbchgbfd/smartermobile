import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/notifiers/leave_notifier.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/config/status_config.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/leave_d_body.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/leave_details_error_state.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class LeaveDetailScreen extends ConsumerStatefulWidget {
  final LeaveEntity? leave;
  final int? leaveId;
  const LeaveDetailScreen({super.key, this.leave, this.leaveId})
    : assert(
        leave != null || leaveId != null,
        'Either leave or leaveId must be provided',
      );
  static Route<void> fromEntity(LeaveEntity leave) =>
      MaterialPageRoute(builder: (_) => LeaveDetailScreen(leave: leave));
  static Route<void> fromId(int leaveId) =>
      MaterialPageRoute(builder: (_) => LeaveDetailScreen(leaveId: leaveId));
  @override
  ConsumerState<LeaveDetailScreen> createState() => _LeaveDetailScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _LeaveDetailScreenState extends ConsumerState<LeaveDetailScreen>
    with SingleTickerProviderStateMixin {
  LeaveEntity? _leave;
  bool _loading = false;
  bool _fetched = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  //////////////////////////////////////////////////////////////////////////////
  /// INITAILIZE STATE
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);

    if (widget.leave != null) {
      _leave = widget.leave;
      _animCtrl.forward();
    } else {
      Future.microtask(() => _fetchById());
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// FETCH DATA BYID
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchById() async {
    if (_fetched) return;
    _fetched = true;
    setState(() => _loading = true);
    final leave = await ref
        .read(managerLeaveProvider.notifier)
        .fetchLeaveById(widget.leaveId!);
    if (!mounted) return;

    setState(() {
      _leave = leave;
      _loading = false;
    });
    if (_leave != null) _animCtrl.forward();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ////////////////////////////////////////////////////////////////////////////
    // ── adaptive palette ──
    ////////////////////////////////////////////////////////////////////////////
    final bg = isDark ? const Color(0xFF0A0A0F) : const Color(0xFFF4F4F8);
    final card = isDark ? const Color(0xFF141418) : Colors.white;
    final border = isDark ? const Color(0xFF232329) : const Color(0xFFE8E8EF);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F0F14);
    final textSecondary = isDark
        ? const Color(0xFF8B8B9A)
        : const Color(0xFF6B6B7A);
    const accent = Color(0xFF6366F1);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      //////////////////////////////////////
      /// APPBAR
      ////////////////////////////////////
      appBar: AppBar(
        backgroundColor: card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(color: textPrimary),
        title: Text(
          'Leave Request',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: border),
        ),
      ),

      ///////////////////////////////////
      ///
      //////////////////////////////////
      body: _loading
          //////////////////////////////
          /// LOADING
          /////////////////////////////
          ? AppListShimmer()
          : _leave == null
          ? ErrorState(
              textSecondary: textSecondary,
              accent: accent,
              onRetry: _fetchById,
            )
          //////////////////////////////
          ///
          /////////////////////////////
          : FadeTransition(
              opacity: _fadeAnim,
              child: LeaveDBody(
                leave: _leave!,
                isDark: isDark,
                bg: bg,
                card: card,
                border: border,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                accent: accent,
                fmtDate: leaveDateFmt,
                calcDays: leaveDays,
                statusCfg: statusCfg(_leave!.status.name),
                typeCfg: typeCfg(_leave!.leaveType.name),
              ),
            ),
    );
  }
}
