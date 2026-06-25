class CategoryEntity {
  final int categoryId;
  final int companyId;
  final String categoryName;
  final double categoryTotal;
  final String? imageUrl;
  final String? imagePublicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.categoryId,
    required this.companyId,
    required this.categoryName,
    required this.categoryTotal,
    this.imageUrl,
    this.imagePublicId,
    required this.createdAt,
    required this.updatedAt,
  });
}
