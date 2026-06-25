import 'dart:io';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAll();
  Future<CategoryEntity> getById(int categoryId);
  Future<CategoryEntity> create({required String categoryName, File? image});
  Future<CategoryEntity> update({required int categoryId, String? categoryName, File? image});
  Future<void> deleteImage(int categoryId);
  Future<void> delete(int categoryId);
}