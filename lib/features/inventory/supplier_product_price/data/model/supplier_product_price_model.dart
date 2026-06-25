import '../../domain/entities/supplier_product_price_entity.dart';

class ProductBriefModel extends ProductBrief {
  const ProductBriefModel({required super.productId, required super.name});

  factory ProductBriefModel.fromJson(Map<String, dynamic> json) {
    return ProductBriefModel(
      productId: json['product_id'] as int,
      name: json['name'] as String,
    );
  }
}

class ProductVariantBriefModel extends ProductVariantBrief {
  const ProductVariantBriefModel({
    required super.variantId,
    super.sku,
    required super.product,
  });

  factory ProductVariantBriefModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantBriefModel(
      variantId: json['variant_id'] as int,
      sku: json['sku'] as String?,
      product: ProductBriefModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );
  }
}

class SupplierProductPriceModel extends SupplierProductPriceEntity {
  const SupplierProductPriceModel({
    required super.priceId,
    required super.supplierId,
    required super.variantId,
    required super.unitPrice,
    super.note,
    required super.variant,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SupplierProductPriceModel.fromJson(Map<String, dynamic> json) {
    return SupplierProductPriceModel(
      priceId: json['price_id'] as int,
      supplierId: json['supplier_id'] as int,
      variantId: json['variant_id'] as int,
      unitPrice: double.tryParse(json['unit_price']?.toString() ?? '') ?? 0,
      note: json['note'] as String?,
      variant: ProductVariantBriefModel.fromJson(
        json['variant'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'price_id': priceId,
    'supplier_id': supplierId,
    'variant_id': variantId,
    'unit_price': unitPrice,
    'note': note,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
