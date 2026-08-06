import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/config/status_c_f_g_type.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/leave_d_section_labe.dart'
    show SectionLabel;
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/card/leave_hero_card.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/card/leave_meta_card.dart'
    show MetaCard;
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/card/leave_reason_card.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/card/leave_time_card.dart';

class LeaveDBody extends StatelessWidget {
  //////////////////////////////////////////////////////////////////////////////
  /// CONSTRUCTOR
  //////////////////////////////////////////////////////////////////////////////
  final LeaveEntity leave;
  final bool isDark;
  final Color bg, card, border, textPrimary, textSecondary, accent;
  final String Function(DateTime?) fmtDate;
  final int Function(DateTime, DateTime) calcDays;
  final StatusCfg statusCfg;
  final TypeCfg typeCfg;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  const LeaveDBody({
    super.key,
    required this.leave,
    required this.isDark,
    required this.bg,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.fmtDate,
    required this.calcDays,
    required this.statusCfg,
    required this.typeCfg,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final days = calcDays(leave.startDate, leave.endDate);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        ////////////////////////////////////////////////////////////////////////
        // ── Hero ──────────────────────────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        HeroCard(
          leave: leave,
          days: days,
          card: card,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          statusCfg: statusCfg,
          typeCfg: typeCfg,
          accent: accent,
        ),
        const SizedBox(height: 20),

        ////////////////////////////////////////////////////////////////////////
        // ── Timeline ──────────────────────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        SectionLabel(label: 'Period', textSecondary: textSecondary),
        const SizedBox(height: 8),
        TimelineCard(
          leave: leave,
          card: card,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          accent: accent,
          fmtDate: fmtDate,
          days: days,
        ),
        const SizedBox(height: 20),

        ////////////////////////////////////////////////////////////////////////
        // ── Reason ────────────────────────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        if (leave.reason != null && leave.reason!.isNotEmpty) ...[
          SectionLabel(label: 'Reason', textSecondary: textSecondary),
          const SizedBox(height: 8),
          ReasonCard(
            reason: leave.reason!,
            card: card,
            border: border,
            textPrimary: textPrimary,
          ),
          const SizedBox(height: 20),
        ],

        ////////////////////////////////////////////////////////////////////////
        // ── Meta ──────────────────────────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        SectionLabel(label: 'Details', textSecondary: textSecondary),
        const SizedBox(height: 8),
        MetaCard(
          leave: leave,
          card: card,
          border: border,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          fmtDate: fmtDate,
          accent: accent,
        ),
      ],
    );
  }
}
