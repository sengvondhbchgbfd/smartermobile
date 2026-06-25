import 'dart:io';
import 'package:frontendmobile/features/inventory/categories/data/datasources/category_remote_datasource.dart';
import 'package:frontendmobile/features/inventory/categories/domain/repositories/category_repository.dart';
import '../../domain/entities/category_entity.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remote;
  const CategoryRepositoryImpl(this._remote);
  @override
  Future<List<CategoryEntity>> getAll() => _remote.getAll();
  @override
  Future<CategoryEntity> getById(int id) => _remote.getById(id);
  @override
  Future<CategoryEntity> create({required String categoryName, File? image}) =>
      _remote.create(categoryName: categoryName, image: image);
  @override
  Future<CategoryEntity> update({
    required int categoryId,
    String? categoryName,
    File? image,
  }) => _remote.update(
    categoryId: categoryId,
    categoryName: categoryName,
    image: image,
  );
  @override
  Future<void> deleteImage(int id) => _remote.deleteImage(id);
  @override
  Future<void> delete(int id) => _remote.delete(id);
}
