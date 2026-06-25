class ProductBrief {
  final int productId;
  final String name;

  const ProductBrief({required this.productId, required this.name});
}

class ProductVariantBrief {
  final int variantId;
  final String? sku;
  final ProductBrief product;

  const ProductVariantBrief({
    required this.variantId,
    this.sku,
    required this.product,
  });
}

class SupplierProductPriceEntity {
  final int priceId;
  final int supplierId;
  final int variantId;
  final double unitPrice;
  final String? note;
  final ProductVariantBrief variant;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierProductPriceEntity({
    required this.priceId,
    required this.supplierId,
    required this.variantId,
    required this.unitPrice,
    this.note,
    required this.variant,
    required this.createdAt,
    required this.updatedAt,
  });

  String get productName => variant.product.name;
  String? get sku => variant.sku;

  SupplierProductPriceEntity copyWith({
    int? priceId,
    int? supplierId,
    int? variantId,
    double? unitPrice,
    String? note,
    bool clearNote = false,
    ProductVariantBrief? variant,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SupplierProductPriceEntity(
    priceId: priceId ?? this.priceId,
    supplierId: supplierId ?? this.supplierId,
    variantId: variantId ?? this.variantId,
    unitPrice: unitPrice ?? this.unitPrice,
    note: clearNote ? null : (note ?? this.note),
    variant: variant ?? this.variant,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
