import 'package:decimal/decimal.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class ProductVariantEntity {
  final int variantId;
  final int productId;
  final String? sku;
  final Map<String, dynamic> specs;
  final Decimal price;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ProductImageEntity> images;

  const ProductVariantEntity({
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

  bool get isInStock => stockQuantity > 0;

  ProductImageEntity? get primaryImage {
    try {
      return images.firstWhere((img) => img.isPrimary);
    } catch (_) {
      return images.isNotEmpty ? images.first : null;
    }
  }

  // -------------------------------------------------------------------------
  // CopyWith
  // -------------------------------------------------------------------------

  ProductVariantEntity copyWith({
    int? variantId,
    int? productId,
    String? sku,
    Map<String, dynamic>? specs,
    Decimal? price,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ProductImageEntity>? images,
  }) {
    return ProductVariantEntity(
      variantId: variantId ?? this.variantId,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      specs: specs ?? this.specs,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariantEntity &&
          runtimeType == other.runtimeType &&
          variantId == other.variantId;

  @override
  int get hashCode => variantId.hashCode;

  @override
  String toString() =>
      'ProductVariantEntity(variantId: $variantId, sku: $sku, '
      'price: $price, stock: $stockQuantity)';
}
