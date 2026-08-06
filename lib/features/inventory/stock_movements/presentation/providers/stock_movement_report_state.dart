import 'package:frontendmobile/features/inventory/stock_movements/domain/entities/stock_movement_report_entity.dart';

const kReportPeriods = ['day', 'week', 'month', 'year', 'all'];

class StockMovementReportState {
  final bool isLoading;
  final String? error;
  final StockMovementReportEntity? report;
  final String period;
  final int? categoryId;
  final int? variantId;
  final bool includeBalance;
  final DateTime? start;
  final DateTime? end;

  const StockMovementReportState({
    this.isLoading = false,
    this.error,
    this.report,
    this.period = 'month',
    this.categoryId,
    this.variantId,
    this.includeBalance = true,
    this.start,
    this.end,
  });

  StockMovementReportState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    StockMovementReportEntity? report,
    String? period,
    int? categoryId,
    bool clearCategory = false,
    int? variantId,
    bool clearVariant = false,
    bool? includeBalance,
    DateTime? start,
    bool clearStart = false,
    DateTime? end,
    bool clearEnd = false,
  }) {
    return StockMovementReportState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      report: report ?? this.report,
      period: period ?? this.period,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      variantId: clearVariant ? null : (variantId ?? this.variantId),
      includeBalance: includeBalance ?? this.includeBalance,
      start: clearStart ? null : (start ?? this.start),
      end: clearEnd ? null : (end ?? this.end),
    );
  }

  bool get hasCustomRange => start != null || end != null;
}
