import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.categoryId,
    required super.companyId,
    required super.categoryName,
    required super.categoryTotal,
    super.imageUrl,
    super.imagePublicId,
    required super.createdAt,
    required super.updatedAt,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
    categoryId: j['category_id'] as int,
    companyId: j['company_id'] as int,
    categoryName: j['category_name'] as String,
    categoryTotal: double.parse(j['category_total'].toString()),
    imageUrl: j['image_url'] as String?,
    imagePublicId: j['image_public_id'] as String?,
    createdAt: DateTime.parse(j['created_at'] as String),
    updatedAt: DateTime.parse(j['updated_at'] as String),
  );
}
