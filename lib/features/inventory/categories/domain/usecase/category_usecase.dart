import 'dart:io';
import 'package:frontendmobile/features/inventory/categories/domain/repositories/category_repository.dart';

import '../entities/category_entity.dart';

class GetAllCategoriesUseCase {
  final CategoryRepository _repo;
  const GetAllCategoriesUseCase(this._repo);
  Future<List<CategoryEntity>> call() => _repo.getAll();
}

class GetCategoryByIdUseCase {
  final CategoryRepository _repo;
  const GetCategoryByIdUseCase(this._repo);
  Future<CategoryEntity> call(int id) => _repo.getById(id);
}

class CreateCategoryUseCase {
  final CategoryRepository _repo;
  const CreateCategoryUseCase(this._repo);
  Future<CategoryEntity> call({required String categoryName, File? image}) =>
      _repo.create(categoryName: categoryName, image: image);
}

class UpdateCategoryUseCase {
  final CategoryRepository _repo;
  const UpdateCategoryUseCase(this._repo);
  Future<CategoryEntity> call({required int categoryId, String? categoryName, File? image}) =>
      _repo.update(categoryId: categoryId, categoryName: categoryName, image: image);
}

class DeleteCategoryImageUseCase {
  final CategoryRepository _repo;
  const DeleteCategoryImageUseCase(this._repo);
  Future<void> call(int id) => _repo.deleteImage(id);
}

class DeleteCategoryUseCase {
  final CategoryRepository _repo;
  const DeleteCategoryUseCase(this._repo);
  Future<void> call(int id) => _repo.delete(id);
}