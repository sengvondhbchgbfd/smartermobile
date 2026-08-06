import 'package:frontendmobile/features/inventory/supplier_product_price/domain/repositories/supplier_product_price_repo.dart';

import '../entities/supplier_product_price_entity.dart';

class GetAllSupplierProductPricesUseCase {
  final SupplierProductPriceRepository _repo;
  GetAllSupplierProductPricesUseCase(this._repo);

  Future<List<SupplierProductPriceEntity>> call({
    int? supplierId,
    int? variantId,
  }) => _repo.getAll(supplierId: supplierId, variantId: variantId);
}

class GetSupplierProductPriceByIdUseCase {
  final SupplierProductPriceRepository _repo;
  GetSupplierProductPriceByIdUseCase(this._repo);

  Future<SupplierProductPriceEntity> call(int priceId) =>
      _repo.getById(priceId);
}

class CreateSupplierProductPriceUseCase {
  final SupplierProductPriceRepository _repo;
  CreateSupplierProductPriceUseCase(this._repo);

  Future<SupplierProductPriceEntity> call({
    required int supplierId,
    required int variantId,
    required double unitPrice,
    String? note,
  }) => _repo.create(
    supplierId: supplierId,
    variantId: variantId,
    unitPrice: unitPrice,
    note: note,
  );
}

class UpdateSupplierProductPriceUseCase {
  final SupplierProductPriceRepository _repo;
  UpdateSupplierProductPriceUseCase(this._repo);

  Future<SupplierProductPriceEntity> call({
    required int priceId,
    int? supplierId,
    int? variantId,
    double? unitPrice,
    String? note,
  }) => _repo.update(
    priceId: priceId,
    supplierId: supplierId,
    variantId: variantId,
    unitPrice: unitPrice,
    note: note,
  );
}

class DeleteSupplierProductPriceUseCase {
  final SupplierProductPriceRepository _repo;
  DeleteSupplierProductPriceUseCase(this._repo);

  Future<void> call(int priceId) => _repo.delete(priceId);
}