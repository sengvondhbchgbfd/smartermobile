import '../../domain/entities/product_entity.dart';

class ProductImageModel extends ProductImageEntity {
  const ProductImageModel({
    required super.imageId,
    required super.productId,
    required super.companyId,
    super.variantId,
    super.imageUrl,
    super.publicId,
    required super.isPrimary,
    required super.sortOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> j) =>
      ProductImageModel(
        imageId: j['images_id'] as int,
        productId: j['product_id'] as int,
        companyId: j['company_id'] as int,
        variantId: j['variant_id'] as int?,
        imageUrl: j['image_url'] as String?,
        publicId: j['public_id'] as String?,
        isPrimary: j['is_primary'] as bool? ?? false,
        sortOrder: j['sort_order'] as int? ?? 0,
      );
  Map<String, dynamic> toJson() => {
    'images_id': imageId,
    'product_id': productId,
    'company_id': companyId,
    'variant_id': variantId,
    'image_url': imageUrl,
    'public_id': publicId,
    'is_primary': isPrimary,
    'sort_order': sortOrder,
  };
}

// ─────────────────────────────────────────────────────────────────────────────

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.variantId,
    required super.productId,
    super.sku,
    super.specs,
    required super.price,
    required super.stockQuantity,
    super.images,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> j) =>
      ProductVariantModel(
        variantId: j['variant_id'] as int,
        productId: j['product_id'] as int,
        sku: j['sku'] as String?,
        specs: (j['specs'] as Map<String, dynamic>? ?? {}),
        price: j['price'] is String
            ? double.parse(j['price'])
            : (j['price'] as num).toDouble(),
        stockQuantity: j['stock_quantity'] as int? ?? 0,
        images: (j['images'] as List? ?? [])
            .map((e) => ProductImageModel.fromJson(e))
            .toList(),
        createdAt: DateTime.parse(j['created_at'] as String),
        updatedAt: DateTime.parse(j['updated_at'] as String),
      );
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.productId,
    required super.companyId,
    super.categoryId,
    required super.name,
    super.description,
    super.variants, // ✅ add
    super.images,
    required super.createdAt,
    required super.updatedAt,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
    productId: j['product_id'] as int,
    companyId: j['company_id'] as int,
    categoryId: j['category_id'] as int?,
    name: j['name'] as String,
    description: j['descriptions'] as String?,
    variants: (j['variants'] as List? ?? [])
        .map((e) => ProductVariantModel.fromJson(e))
        .toList(),
    images: (j['images'] as List? ?? [])
        .map((e) => ProductImageModel.fromJson(e))
        .toList(),
    createdAt: DateTime.parse(j['created_at'] as String),
    updatedAt: DateTime.parse(j['updated_at'] as String),
  );
}
