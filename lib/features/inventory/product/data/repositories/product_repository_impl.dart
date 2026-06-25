import 'dart:io';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  const ProductRepositoryImpl(this._remote);

  @override
  Future<List<ProductEntity>> getAll({int? categoryId}) =>
      _remote.getAll(categoryId: categoryId);

  @override
  Future<ProductEntity> getById(int id) => _remote.getById(id);

  @override
  Future<ProductEntity> create({
    required String name,
    int? categoryId,
    String? description,
  }) => _remote.create(
    name:        name,
    categoryId:  categoryId,
    description: description,
  );

  @override
  Future<ProductEntity> update({
    required int productId,
    String? name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity
  }) => _remote.update(
    productId:   productId,
    name:        name,
    categoryId:  categoryId,
    description: description,
  );

  @override
  Future<ProductImageEntity> addImage({
    required int productId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) => _remote.addImage(
    productId: productId,
    image:     image,
    isPrimary: isPrimary,
    sortOrder: sortOrder,
  );

  @override
  Future<ProductImageEntity> setPrimaryImage({
    required int productId,
    required int imageId,
  }) => _remote.setPrimaryImage(
    productId: productId,
    imageId:   imageId,
  );

  @override
  Future<void> deleteImage({
    required int productId,
    required int imageId,
  }) => _remote.deleteImage(
    productId: productId,
    imageId:   imageId,
  );

  @override
  Future<void> delete(int id) => _remote.delete(id);
}