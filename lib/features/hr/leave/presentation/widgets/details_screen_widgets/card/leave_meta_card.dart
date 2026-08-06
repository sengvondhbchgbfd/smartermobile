import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/leave_meta_row.dart'
    show MetaRow;
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';

class MetaCard extends ConsumerWidget {
  final LeaveEntity leave;
  final Color card, border, textPrimary, textSecondary, accent;
  final String Function(DateTime?) fmtDate;

  const MetaCard({
    super.key,
    required this.leave,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.fmtDate,
    required this.accent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///////////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////////
    final approverName = leave.approvedByName ?? 'User #${leave.approvedBy}';
    ////////////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////////

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          MetaRow(
            icon: Icons.schedule_rounded,
            label: 'Submitted',
            value: fmtDate(leave.createdAt),
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            border: border,
            isFirst: true,
            isLast: leave.approvedBy == null,
          ),
          if (leave.approvedBy != null)
            MetaRow(
              icon: Icons.verified_user_rounded,
              label: 'Approved by',
              value: approverName,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              valueColor: accent,
              border: border,
              isLast: true,
            ),
        ],
      ),
    );
  }
}
