import '../entities/stock_movement_entity.dart';
import '../repositories/stock_movement_repository.dart';

class GetAllStockMovementsUseCase {
  final StockMovementRepository _repo;
  const GetAllStockMovementsUseCase(this._repo);

  Future<List<StockMovementEntity>> call({int? variantId}) => // ✅
      _repo.getAll(variantId: variantId);
}

class GetStockMovementByIdUseCase {
  final StockMovementRepository _repo;
  const GetStockMovementByIdUseCase(this._repo);

  Future<StockMovementEntity> call(int id) => _repo.getById(id);
}

class CreateStockMovementUseCase {
  final StockMovementRepository _repo;
  const CreateStockMovementUseCase(this._repo);

  Future<StockMovementEntity> call({
    required int variantId, // ✅
    required int productId,
    required int qtyIn,
    required int qtyOut,
    required String movementType, // ✅
    required DateTime date, // ✅
  }) => _repo.create(
    variantId: variantId,
    productId: productId,
    qtyIn: qtyIn,
    qtyOut: qtyOut,
    movementType: movementType,
    date: date,
  );
}

class DeleteStockMovementUseCase {
  final StockMovementRepository _repo;
  const DeleteStockMovementUseCase(this._repo);

  Future<void> call(int id) => _repo.delete(id);
}
