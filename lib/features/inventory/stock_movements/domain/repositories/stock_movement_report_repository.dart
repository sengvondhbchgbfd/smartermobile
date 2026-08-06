import '../entities/stock_movement_report_entity.dart';

abstract class StockMovementReportRepository {
  Future<StockMovementReportEntity> getReport({
    String period = 'all',
    int? categoryId,
    int? variantId,
    bool includeBalance = false,
    DateTime? start,
    DateTime? end,
  });
}
