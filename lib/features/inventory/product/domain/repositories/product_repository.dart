import 'dart:io';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAll({int? categoryId});
  Future<ProductEntity> getById(int productId);

  Future<ProductEntity> create({
    required String name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity → now on variant
  });

  Future<ProductEntity> update({
    required int productId,
    String? name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity → now on variant
  });

  Future<ProductImageEntity> addImage({
    required int productId,
    required File image,
    bool isPrimary,
    int sortOrder,
  });

  Future<ProductImageEntity> setPrimaryImage({
    required int productId,
    required int imageId,
  });

  Future<void> deleteImage({required int productId, required int imageId});
  Future<void> delete(int productId);
}