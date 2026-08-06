import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/screens/stock_trend_chart.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/bucket_card.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/closing_stock_summary.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/net_value_hero.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/report_state_row.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/section_title.dart';
import '../../../domain/entities/stock_movement_report_entity.dart';

class ReportContentList extends StatelessWidget {
  const ReportContentList({
    super.key,
    required this.report,
    required this.period,
    required this.trendPoints,
    required this.money,
    required this.green,
    required this.red,
    required this.card,
    required this.border,
    required this.sub,
    required this.textPrimary,
    required this.isDark,
    required this.periodLabel,
  });

  final StockMovementReportEntity report;
  final String period;
  final List<StockMovementTrendPoint> trendPoints;
  final String Function(double) money;
  final Color green;
  final Color red;
  final Color card;
  final Color border;
  final Color sub;
  final Color textPrimary;
  final bool isDark;
  final String Function(String) periodLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
      children: [
        NetValueHero(
          value: money(report.totalNetValue),
          qtyIn: report.totalQtyIn,
          qtyOut: report.totalQtyOut,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        ReportStatsRow(
          report: report,
          green: green,
          red: red,
          card: card,
          border: border,
          sub: sub,
          textPrimary: textPrimary,
        ),
        const SizedBox(height: 12),
        ClosingStockSummary(
          report: report,
          card: card,
          border: border,
          sub: sub,
          textPrimary: textPrimary,
          isDark: isDark,
        ),
        if (period != 'all') ...[
          const SizedBox(height: 24),
          SectionTitle(icon: Icons.show_chart_rounded, text: 'Trend', sub: sub),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border, width: 0.6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: StockTrendChart(
              points: trendPoints,
              inColor: green,
              outColor: red,
              subText: sub,
              gridColor: border,
            ),
          ),
        ],
        const SizedBox(height: 24),
        SectionTitle(
          icon: Icons.inventory_2_rounded,
          text:
              'By variant · ${periodLabel(period)} (${report.buckets.length})',
          sub: sub,
        ),
        const SizedBox(height: 10),
        if (report.buckets.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No movements in this range.',
                style: TextStyle(fontSize: 13, color: sub),
              ),
            ),
          )
        else
          ...report.buckets.map(
            (b) => BucketCard(
              bucket: b,
              card: card,
              border: border,
              sub: sub,
              textPrimary: textPrimary,
              isDark: isDark,
              money: money,
              inColor: green,
              outColor: red,
            ),
          ),
      ],
    );
  }
}
