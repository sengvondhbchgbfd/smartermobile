import 'package:frontendmobile/features/inventory/supplier_product_price/data/datasource/supplier_product_price_datasource.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/domain/repositories/supplier_product_price_repo.dart';

import '../../domain/entities/supplier_product_price_entity.dart';

class SupplierProductPriceRepositoryImpl
    implements SupplierProductPriceRepository {
  final SupplierProductPriceRemoteDataSource _remote;
  SupplierProductPriceRepositoryImpl(this._remote);

  @override
  Future<List<SupplierProductPriceEntity>> getAll({
    int? supplierId,
    int? variantId,
  }) => _remote.getAll(supplierId: supplierId, variantId: variantId);

  @override
  Future<SupplierProductPriceEntity> getById(int priceId) =>
      _remote.getById(priceId);

  @override
  Future<SupplierProductPriceEntity> create({
    required int supplierId,
    required int variantId,
    required double unitPrice,
    String? note,
  }) => _remote.create(
    supplierId: supplierId,
    variantId: variantId,
    unitPrice: unitPrice,
    note: note,
  );

  @override
  Future<SupplierProductPriceEntity> update({
    required int priceId,
    int? supplierId,
    int? variantId,
    double? unitPrice,
    String? note,
  }) => _remote.update(
    priceId: priceId,
    supplierId: supplierId,
    variantId: variantId,
    unitPrice: unitPrice,
    note: note,
  );
  @override
  Future<void> delete(int priceId) => _remote.delete(priceId);
}
