import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/report_period_picker.dart';
import 'package:frontendmobile/core/utils/stock_report_export.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/category_chip.dart'
    show CategoryChip;
import 'package:frontendmobile/features/inventory/stock_movements/presentation/providers/stock_movement_report_state.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/report/report_list_content.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../providers/stock_movement_report_provider.dart';
import '../../domain/entities/stock_movement_report_entity.dart';
import '../widgets/report/report_export_menu.dart';
import '../widgets/report/report_category_filter.dart';

class StockMovementReportScreen extends ConsumerStatefulWidget {
  const StockMovementReportScreen({super.key});
  @override
  ConsumerState<StockMovementReportScreen> createState() =>
      _StockMovementReportScreenState();
}

class _StockMovementReportScreenState
    extends ConsumerState<StockMovementReportScreen> {
  //////////////////////////////////////////////////////////////////////////
  static const _green = Color(0xFF12B886);
  static const _red = Color(0xFFE8555A);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
  Color get _card => _isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
  Color get _border => _isDark ? Pallets.borderDark : Pallets.borderLight;
  Color get _sub =>
      _isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
  Color get _textPrimary =>
      _isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
  bool _exporting = false;

  //////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(stockMovementReportNotifierProvider.notifier);
      final period = ref.read(stockMovementReportNotifierProvider).period;
      if (period == 'month') {
        notifier.setMonth(DateTime.now());
      } else if (period == 'year') {
        notifier.setYear(DateTime.now().year);
      } else {
        notifier.load();
      }
      ref.read(categoryNotifierProvider.notifier).loadAll();
    });
  }

  //////////////////////////////////////////////////////////////////////////
  String _periodLabel(String p) {
    switch (p) {
      case 'day':
        return 'Day';
      case 'week':
        return 'Week';
      case 'month':
        return 'Month';
      case 'year':
        return 'Year';
      default:
        return 'All time';
    }
  }

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  Future<void> _export(StockMovementReportEntity report, String kind) async {
    setState(() => _exporting = true);
    try {
      final state = ref.read(stockMovementReportNotifierProvider);
      if (kind == 'excel') {
        await StockReportExport.exportExcel(
          report,
          state.period,
          start: state.start,
          end: state.end,
        );
      } else {
        await StockReportExport.exportPdf(
          report,
          state.period,
          start: state.start,
          end: state.end,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: 'Export failed: $e',
        type: SnackType.error,
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockMovementReportNotifierProvider);
    final notifier = ref.read(stockMovementReportNotifierProvider.notifier);
    final report = state.report;
    final categories = ref.watch(categoryNotifierProvider).categories;

    final trendPoints = report != null
        ? StockMovementTrendPoint.fromBuckets(report.buckets)
        : <StockMovementTrendPoint>[];

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        surfaceTintColor: Pallets.transparent,
        title: Text(
          'Stock Report',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.4,
            color: _textPrimary,
          ),
        ),
        actions: [
          if (report != null)
            ReportExportMenu(
              exporting: _exporting,
              onSelected: (kind) => _export(report, kind),
            ),
        ],
      ),
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),

          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              children: kReportPeriods.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChip(
                    label: _periodLabel(p),
                    selected: state.period == p,
                    onTap: () => notifier.setPeriod(p),
                    selectedColor: Pallets.blurple,
                    border: _border,
                    sub: _sub,
                  ),
                );
              }).toList(),
            ),
          ),

          //////////////////////////////////////////////////////////////////////
          // ── Adaptive picker: date range / month / year / none ──────────
          //////////////////////////////////////////////////////////////////////
          ReportPeriodPicker(
            state: state,
            notifier: notifier,
            card: _card,
            border: _border,
            sub: _sub,
            textPrimary: _textPrimary,
          ),

          ReportCategoryFilter(
            categories: categories,
            selectedCategoryId: state.categoryId,
            onSelect: notifier.setCategory,
            border: _border,
            sub: _sub,
          ),

          const SizedBox(height: 6),

          Expanded(
            child: state.isLoading && report == null
                ? const AppListShimmer(itemCount: 6)
                : report == null
                ? Center(
                    child: Text(
                      'No data.',
                      style: TextStyle(fontSize: 14, color: _sub),
                    ),
                  )
                : RefreshIndicator(
                    color: Pallets.blurple,
                    backgroundColor: _card,
                    onRefresh: notifier.load,
                    child: ReportContentList(
                      report: report,
                      period: state.period,
                      trendPoints: trendPoints,
                      money: _money,
                      green: _green,
                      red: _red,
                      card: _card,
                      border: _border,
                      sub: _sub,
                      textPrimary: _textPrimary,
                      isDark: _isDark,
                      periodLabel: _periodLabel,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
