import 'package:frontendmobile/features/inventory/stock_movements/domain/entities/stock_movement_entity.dart';

abstract class StockMovementRepository {
  Future<List<StockMovementEntity>> getAll({int? variantId});
  Future<StockMovementEntity> getById(int movementId);
  Future<StockMovementEntity> create({
    required int variantId,
    required int productId,        // ← add this
    required int qtyIn,
    required int qtyOut,
    required String movementType,
    required DateTime date,
  });
  Future<void> delete(int movementId);
}