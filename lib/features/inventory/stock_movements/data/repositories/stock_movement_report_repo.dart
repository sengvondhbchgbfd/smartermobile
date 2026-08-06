import 'package:frontendmobile/features/inventory/stock_movements/data/datasources/stock_movement_report_remote_datasource.dart';

import '../../domain/entities/stock_movement_report_entity.dart';
import '../../domain/repositories/stock_movement_report_repository.dart';

class StockMovementReportRepositoryImpl
    implements StockMovementReportRepository {
  final StockMovementReportRemoteDataSource _remote;
  const StockMovementReportRepositoryImpl(this._remote);
  @override
  Future<StockMovementReportEntity> getReport({
    String period = 'all',
    int? categoryId,
    int? variantId,
    bool includeBalance = false,
    DateTime? start,
    DateTime? end,
  }) async {
    return _remote.getReport(
      period: period,
      categoryId: categoryId,
      variantId: variantId,
      includeBalance: includeBalance,
      start: start,
      end: end,
    );
  }
}
