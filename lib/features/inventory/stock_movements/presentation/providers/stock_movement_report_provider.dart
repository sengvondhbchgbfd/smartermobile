import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/providers/stock_movement_report_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/stock_movement_report_remote_datasource.dart';
import '../../data/repositories/stock_movement_report_repo.dart';
import '../../domain/repositories/stock_movement_report_repository.dart';
part 'stock_movement_report_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

@riverpod
Future<StockMovementReportRemoteDataSource> stockMovementReportDataSource(
  Ref ref,
) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return StockMovementReportRemoteDataSourceImpl(dioClient);
}

@riverpod
Future<StockMovementReportRepository> stockMovementReportRepository(
  Ref ref,
) async {
  final dataSource = await ref.watch(
    stockMovementReportDataSourceProvider.future,
  );
  return StockMovementReportRepositoryImpl(dataSource);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class StockMovementReportNotifier extends _$StockMovementReportNotifier {
  @override
  StockMovementReportState build() => const StockMovementReportState();

  Future<StockMovementReportRepository> get _repo =>
      ref.read(stockMovementReportRepositoryProvider.future);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = await _repo;
      final report = await repo.getReport(
        period: state.period,
        categoryId: state.categoryId,
        variantId: state.variantId,
        includeBalance: state.includeBalance,
        start: state.start,
        end: state.end,
      );
      state = state.copyWith(isLoading: false, report: report);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load report: $e',
      );
    }
  }

  Future<void> setPeriod(String period) async {
    if (period == 'month') {
      await setMonth(DateTime.now());
      return;
    }
    if (period == 'year') {
      await setYear(DateTime.now().year);
      return;
    }
    state = state.copyWith(period: period, clearStart: true, clearEnd: true);
    await load();
  }

  Future<void> setMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = month.month == 12
        ? DateTime(month.year + 1, 1, 1)
        : DateTime(month.year, month.month + 1, 1);
    state = state.copyWith(period: 'month', start: start, end: end);
    await load();
  }

  /// Scopes the report to a specific calendar year (e.g. reviewing old
  /// stock from a past year).
  Future<void> setYear(int year) async {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    state = state.copyWith(period: 'year', start: start, end: end);
    await load();
  }

  /// Sets an arbitrary custom date range, used for 'day'/'week' periods
  /// (or any period) when the user wants to review an exact old date
  /// range rather than a whole month/year.
  Future<void> setDateRange({DateTime? start, DateTime? end}) async {
    state = state.copyWith(start: start, end: end);
    await load();
  }

  Future<void> clearDateRange() async {
    state = state.copyWith(clearStart: true, clearEnd: true);
    await load();
  }

  Future<void> setCategory(int? categoryId) async {
    state = state.copyWith(
      categoryId: categoryId,
      clearCategory: categoryId == null,
    );
    await load();
  }

  Future<void> setVariant(int? variantId) async {
    state = state.copyWith(
      variantId: variantId,
      clearVariant: variantId == null,
    );
    await load();
  }

  void clearError() => state = state.copyWith(clearError: true);
}
