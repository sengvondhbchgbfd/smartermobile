import 'package:decimal/decimal.dart';
import 'package:frontendmobile/features/inventory/product/data/models/product_model.dart';

import '../../domain/entities/product_variant_entity.dart';

class ProductVariantModel {
  final int variantId;
  final int productId;
  final String? sku;
  final Map<String, dynamic> specs;
  final Decimal price;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ProductImageModel> images;
  const ProductVariantModel({
    required this.variantId,
    required this.productId,
    this.sku,
    required this.specs,
    required this.price,
    required this.stockQuantity,
    required this.createdAt,
    this.updatedAt,
    this.images = const [],
  });

  // -------------------------------------------------------------------------
  // fromJson
  // -------------------------------------------------------------------------

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      variantId: json['variant_id'] as int,
      productId: json['product_id'] as int,
      sku: json['sku'] as String?,
      specs: (json['specs'] as Map<String, dynamic>?) ?? {},
      price: Decimal.parse(json['price'].toString()),
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (e) => ProductImageModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  // -------------------------------------------------------------------------
  // toJson
  // -------------------------------------------------------------------------

  Map<String, dynamic> toJson() => {
    'variant_id': variantId,
    'product_id': productId,
    'sku': sku,
    'specs': specs,
    'price': price.toString(),
    'stock_quantity': stockQuantity,
    'created_at': createdAt.toIso8601String(),
    if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    'images': images.map((e) => e.toJson()).toList(),
  };

  // -------------------------------------------------------------------------
  // toEntity  →  converts model to domain entity
  // -------------------------------------------------------------------------

  ProductVariantEntity toEntity() => ProductVariantEntity(
    variantId: variantId,
    productId: productId,
    sku: sku,
    specs: specs,
    price: price,
    stockQuantity: stockQuantity,
    createdAt: createdAt,
    updatedAt: updatedAt,
    images: images,
  );

  // -------------------------------------------------------------------------
  // fromEntity  →  converts domain entity back to model
  // -------------------------------------------------------------------------

  factory ProductVariantModel.fromEntity(ProductVariantEntity entity) {
    return ProductVariantModel(
      variantId: entity.variantId,
      productId: entity.productId,
      sku: entity.sku,
      specs: entity.specs,
      price: entity.price,
      stockQuantity: entity.stockQuantity,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      images: entity.images.whereType<ProductImageModel>().toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// ProductVariantCreateModel  –  payload for POST
// ---------------------------------------------------------------------------

class ProductVariantCreateModel {
  final String? sku;
  final Map<String, dynamic> specs;
  final Decimal price;
  final int stockQuantity;
  const ProductVariantCreateModel({
    this.sku,
    this.specs = const {},
    required this.price,
    this.stockQuantity = 0,
  });

  Map<String, dynamic> toJson() => {
    if (sku != null) 'sku': sku,
    'specs': specs,
    'price': price.toString(),
    'stock_quantity': stockQuantity,
  };
}

// ---------------------------------------------------------------------------
// ProductVariantUpdateModel  –  payload for PATCH (only non-null fields sent)
// ---------------------------------------------------------------------------

class ProductVariantUpdateModel {
  final String? sku;
  final Map<String, dynamic>? specs;
  final Decimal? price;
  final int? stockQuantity;

  const ProductVariantUpdateModel({
    this.sku,
    this.specs,
    this.price,
    this.stockQuantity,
  });

  Map<String, dynamic> toJson() => {
    if (sku != null) 'sku': sku,
    if (specs != null) 'specs': specs,
    if (price != null) 'price': price.toString(),
    if (stockQuantity != null) 'stock_quantity': stockQuantity,
  };
}
