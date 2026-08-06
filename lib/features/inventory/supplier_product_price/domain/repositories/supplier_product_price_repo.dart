import '../entities/supplier_product_price_entity.dart';

abstract class SupplierProductPriceRepository {
  Future<List<SupplierProductPriceEntity>> getAll({
    int? supplierId,
    int? variantId,
  });

  Future<SupplierProductPriceEntity> getById(int priceId);

  Future<SupplierProductPriceEntity> create({
    required int supplierId,
    required int variantId,
    required double unitPrice,
    String? note,
  });

  Future<SupplierProductPriceEntity> update({
    required int priceId,
    int? supplierId,
    int? variantId,
    double? unitPrice,
    String? note,
  });

  Future<void> delete(int priceId);
}
