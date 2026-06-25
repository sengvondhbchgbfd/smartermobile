import 'dart:io';

import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

abstract class ProductVariantRepository {
  Future<List<ProductVariantEntity>> getAll(int productId);
  Future<ProductVariantEntity> getById(int productId, int variantId);
  Future<ProductVariantEntity> create({
    required int productId,
    String? sku,
    required Map<String, dynamic> specs,
    required double price,
    required int stockQuantity,
  });
  Future<ProductVariantEntity> update({
    required int productId,
    required int variantId,
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
  });
  Future<void> delete(int productId, int variantId);

  Future<ProductImageEntity> addImage({
    required int productId,
    required int variantId,
    required File image,
    bool isPrimary,
    int sortOrder,
  });
  Future<ProductImageEntity> setPrimaryImage({
    required int productId,
    required int variantId,
    required int imageId,
  });
  Future<void> deleteImage({
    required int productId,
    required int variantId,
    required int imageId,
  });
}
