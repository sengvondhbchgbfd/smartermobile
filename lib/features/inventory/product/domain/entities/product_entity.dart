class ProductImageEntity {
  final int imageId;
  final int productId;
  final int companyId;
  final int? variantId;
  final String? imageUrl;
  final String? publicId;
  final bool isPrimary;
  final int sortOrder;

  const ProductImageEntity({
    required this.imageId,
    required this.productId,
    required this.companyId,
    this.variantId,
    this.imageUrl,
    this.publicId,
    required this.isPrimary,
    required this.sortOrder,
  });
}

// ─────────────────────────────────────────────────────────────────────────────

class ProductVariantEntity {
  final int variantId;
  final int productId;
  final String? sku;
  final Map<String, dynamic> specs;
  final double price;
  final int stockQuantity;
  final List<ProductImageEntity> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductVariantEntity({
    required this.variantId,
    required this.productId,
    this.sku,
    this.specs = const {},
    required this.price,
    required this.stockQuantity,
    this.images = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String? get primaryImageUrl {
    try {
      return images.firstWhere((i) => i.isPrimary).imageUrl;
    } catch (_) {
      return images.isNotEmpty ? images.first.imageUrl : null;
    }
  }

  ProductVariantEntity copyWith({
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
    List<ProductImageEntity>? images,
  }) => ProductVariantEntity(
    variantId: variantId,
    productId: productId,
    sku: sku ?? this.sku,
    specs: specs ?? this.specs,
    price: price ?? this.price,
    stockQuantity: stockQuantity ?? this.stockQuantity,
    images: images ?? this.images,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class ProductEntity {
  final int productId;
  final int companyId;
  final int? categoryId;
  final String name;
  final String? description;
  final List<ProductVariantEntity> variants;
  final List<ProductImageEntity> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.productId,
    required this.companyId,
    this.categoryId,
    required this.name,
    this.description,
    this.variants = const [],
    this.images = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // ✅ convenience getters from first variant
  double? get price => variants.isNotEmpty ? variants.first.price : null;
  int? get stockQuantity =>
      variants.isNotEmpty ? variants.first.stockQuantity : null;

  String? get primaryImageUrl {
    // check product-level images first
    try {
      return images.firstWhere((i) => i.isPrimary).imageUrl;
    } catch (_) {}
    if (images.isNotEmpty) return images.first.imageUrl;
    // fallback to first variant image
    for (final v in variants) {
      final url = v.primaryImageUrl;
      if (url != null) return url;
    }
    return null;
  }

  ProductEntity copyWith({
    int? categoryId,
    String? name,
    String? description,
    List<ProductVariantEntity>? variants,
    List<ProductImageEntity>? images,
  }) => ProductEntity(
    productId: productId,
    companyId: companyId,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description ?? this.description,
    variants: variants ?? this.variants,
    images: images ?? this.images,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
