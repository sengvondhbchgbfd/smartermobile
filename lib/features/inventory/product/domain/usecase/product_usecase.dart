import 'dart:io';
import 'package:frontendmobile/features/inventory/product/domain/repositories/product_repository.dart';
import '../entities/product_entity.dart';

class GetAllProductsUseCase {
  final ProductRepository _repo;
  const GetAllProductsUseCase(this._repo);
  Future<List<ProductEntity>> call({int? categoryId}) =>
      _repo.getAll(categoryId: categoryId);
}

class GetProductByIdUseCase {
  final ProductRepository _repo;
  const GetProductByIdUseCase(this._repo);
  Future<ProductEntity> call(int id) => _repo.getById(id);
}

class CreateProductUseCase {
  final ProductRepository _repo;
  const CreateProductUseCase(this._repo);
  Future<ProductEntity> call({
    required String name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity
  }) => _repo.create(
    name: name,
    categoryId: categoryId,
    description: description,
  );
}

class UpdateProductUseCase {
  final ProductRepository _repo;
  const UpdateProductUseCase(this._repo);
  Future<ProductEntity> call({
    required int productId,
    String? name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity
  }) => _repo.update(
    productId: productId,
    name: name,
    categoryId: categoryId,
    description: description,
  );
}

class AddProductImageUseCase {
  final ProductRepository _repo;
  const AddProductImageUseCase(this._repo);
  Future<ProductImageEntity> call({
    required int productId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) => _repo.addImage(
    productId: productId,
    image: image,
    isPrimary: isPrimary,
    sortOrder: sortOrder,
  );
}

class SetPrimaryImageUseCase {
  final ProductRepository _repo;
  const SetPrimaryImageUseCase(this._repo);
  Future<ProductImageEntity> call({
    required int productId,
    required int imageId,
  }) => _repo.setPrimaryImage(productId: productId, imageId: imageId);
}

class DeleteProductImageUseCase {
  final ProductRepository _repo;
  const DeleteProductImageUseCase(this._repo);
  Future<void> call({required int productId, required int imageId}) =>
      _repo.deleteImage(productId: productId, imageId: imageId);
}

class DeleteProductUseCase {
  final ProductRepository _repo;
  const DeleteProductUseCase(this._repo);
  Future<void> call(int id) => _repo.delete(id);
}
