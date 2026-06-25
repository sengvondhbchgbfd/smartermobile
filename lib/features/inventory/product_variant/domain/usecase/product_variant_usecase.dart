import 'dart:io';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

import '../repositories/product_variant_repository.dart';

class GetAllVariantsUseCase {
  final ProductVariantRepository _repo;
  const GetAllVariantsUseCase(this._repo);
  Future<List<ProductVariantEntity>> call(int productId) =>
      _repo.getAll(productId);
}

class GetVariantByIdUseCase {
  final ProductVariantRepository _repo;
  const GetVariantByIdUseCase(this._repo);
  Future<ProductVariantEntity> call(int productId, int variantId) =>
      _repo.getById(productId, variantId);
}

class CreateVariantUseCase {
  final ProductVariantRepository _repo;
  const CreateVariantUseCase(this._repo);
  Future<ProductVariantEntity> call({
    required int productId,
    String? sku,
    required Map<String, dynamic> specs,
    required double price,
    required int stockQuantity,
  }) => _repo.create(
    productId:     productId,
    sku:           sku,
    specs:         specs,
    price:         price,
    stockQuantity: stockQuantity,
  );
}

class UpdateVariantUseCase {
  final ProductVariantRepository _repo;
  const UpdateVariantUseCase(this._repo);
  Future<ProductVariantEntity> call({
    required int productId,
    required int variantId,
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
  }) => _repo.update(
    productId:     productId,
    variantId:     variantId,
    sku:           sku,
    specs:         specs,
    price:         price,
    stockQuantity: stockQuantity,
  );
}

class DeleteVariantUseCase {
  final ProductVariantRepository _repo;
  const DeleteVariantUseCase(this._repo);
  Future<void> call(int productId, int variantId) =>
      _repo.delete(productId, variantId);
}

class AddVariantImageUseCase {
  final ProductVariantRepository _repo;
  const AddVariantImageUseCase(this._repo);
  Future<ProductImageEntity> call({
    required int productId,
    required int variantId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) => _repo.addImage(
    productId: productId,
    variantId: variantId,
    image:     image,
    isPrimary: isPrimary,
    sortOrder: sortOrder,
  );
}

class SetPrimaryVariantImageUseCase {
  final ProductVariantRepository _repo;
  const SetPrimaryVariantImageUseCase(this._repo);
  Future<ProductImageEntity> call({
    required int productId,
    required int variantId,
    required int imageId,
  }) => _repo.setPrimaryImage(
    productId: productId,
    variantId: variantId,
    imageId:   imageId,
  );
}

class DeleteVariantImageUseCase {
  final ProductVariantRepository _repo;
  const DeleteVariantImageUseCase(this._repo);
  Future<void> call({
    required int productId,
    required int variantId,
    required int imageId,
  }) => _repo.deleteImage(
    productId: productId,
    variantId: variantId,
    imageId:   imageId,
  );
}