import '../../domain/entities/stock_movement_entity.dart';
import '../../domain/repositories/stock_movement_repository.dart';
import '../datasources/stock_movement_remote_datasource.dart';

class StockMovementRepositoryImpl implements StockMovementRepository {
  final StockMovementRemoteDataSource _remote;
  const StockMovementRepositoryImpl(this._remote);

  @override
  Future<List<StockMovementEntity>> getAll({int? variantId}) =>   // ✅
      _remote.getAll(variantId: variantId);

  @override
  Future<StockMovementEntity> getById(int movementId) =>
      _remote.getById(movementId);

  @override
  Future<StockMovementEntity> create({
    required int variantId, 
    required int productId, // ✅       // ✅
    required int qtyIn,
    required int qtyOut,
    required String movementType,  // ✅
    required DateTime date,        // ✅
  }) => _remote.create(
    variantId:    variantId,
    productId: productId,
    qtyIn:        qtyIn,
    qtyOut:       qtyOut,
    movementType: movementType,
    date:         date,
  );

  @override
  Future<void> delete(int movementId) => _remote.delete(movementId);
}