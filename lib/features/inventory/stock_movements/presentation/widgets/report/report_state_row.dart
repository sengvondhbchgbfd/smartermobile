import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/stat_pile.dart';
import '../../../domain/entities/stock_movement_report_entity.dart';

class ReportStatsRow extends StatelessWidget {
  const ReportStatsRow({
    super.key,
    required this.report,
    required this.green,
    required this.red,
    required this.card,
    required this.border,
    required this.sub,
    required this.textPrimary,
  });

  final StockMovementReportEntity report;
  final Color green;
  final Color red;
  final Color card;
  final Color border;
  final Color sub;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    final moves = report.buckets.fold<int>(0, (a, b) => a + b.movementCount);

    return Row(
      children: [
        Expanded(
          child: StatPill(
            icon: Icons.trending_up_rounded,
            label: 'Qty In',
            value: '${report.totalQtyIn}',
            accent: green,
            card: card,
            border: border,
            sub: sub,
            textPrimary: textPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatPill(
            icon: Icons.trending_down_rounded,
            label: 'Qty Out',
            value: '${report.totalQtyOut}',
            accent: red,
            card: card,
            border: border,
            sub: sub,
            textPrimary: textPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatPill(
            icon: Icons.swap_horiz_rounded,
            label: 'Moves',
            value: '$moves',
            accent: Pallets.blurple,
            card: card,
            border: border,
            sub: sub,
            textPrimary: textPrimary,
          ),
        ),
      ],
    );
  }
}
