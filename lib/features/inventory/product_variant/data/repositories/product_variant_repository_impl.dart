import 'dart:io';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

import '../../domain/repositories/product_variant_repository.dart';
import '../datasources/product_variant_remote_datasource.dart';

class ProductVariantRepositoryImpl implements ProductVariantRepository {
  final ProductVariantRemoteDataSource _remote;
  const ProductVariantRepositoryImpl(this._remote);

  @override
  Future<List<ProductVariantEntity>> getAll(int productId) =>
      _remote.getAll(productId);

  @override
  Future<ProductVariantEntity> getById(int productId, int variantId) =>
      _remote.getById(productId, variantId);

  @override
  Future<ProductVariantEntity> create({
    required int productId,
    String? sku,
    required Map<String, dynamic> specs,
    required double price,
    required int stockQuantity,
  }) => _remote.create(
    productId: productId,
    sku: sku,
    specs: specs,
    price: price,
    stockQuantity: stockQuantity,
  );

  @override
  Future<ProductVariantEntity> update({
    required int productId,
    required int variantId,
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
  }) => _remote.update(
    productId: productId,
    variantId: variantId,
    sku: sku,
    specs: specs,
    price: price,
    stockQuantity: stockQuantity,
  );

  @override
  Future<void> delete(int productId, int variantId) =>
      _remote.delete(productId, variantId);

  @override
  Future<ProductImageEntity> addImage({
    required int productId,
    required int variantId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) => _remote.addImage(
    productId: productId,
    variantId: variantId,
    image: image,
    isPrimary: isPrimary,
    sortOrder: sortOrder,
  );

  @override
  Future<ProductImageEntity> setPrimaryImage({
    required int productId,
    required int variantId,
    required int imageId,
  }) => _remote.setPrimaryImage(
    productId: productId,
    variantId: variantId,
    imageId: imageId,
  );

  @override
  Future<void> deleteImage({
    required int productId,
    required int variantId,
    required int imageId,
  }) => _remote.deleteImage(
    productId: productId,
    variantId: variantId,
    imageId: imageId,
  );
}
