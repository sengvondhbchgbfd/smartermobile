class StockMovementReportBucket {
  final String periodLabel;
  final int? categoryId;
  final String? categoryName;
  final int? productId;
  final String? productName;
  final String? productDescription;
  final int? variantId;
  final String? variantSku;
  final Map<String, dynamic> variantSpecs;
  final double? price;
  final int qtyIn;
  final int qtyOut;
  final int netChange;
  final int movementCount;
  final double valueIn;
  final double valueOut;
  final double netValue;
  final int? openingBalance;
  final int? closingBalance;
  final double? closingStockValue;

  const StockMovementReportBucket({
    required this.periodLabel,
    this.categoryId,
    this.categoryName,
    this.productId,
    this.productName,
    this.productDescription,
    this.variantId,
    this.variantSku,
    this.variantSpecs = const {},
    this.price,
    required this.qtyIn,
    required this.qtyOut,
    required this.netChange,
    required this.movementCount,
    required this.valueIn,
    required this.valueOut,
    required this.netValue,
    this.openingBalance,
    this.closingBalance,
    this.closingStockValue,
  });

  String get displayName {
    if (productName != null && variantSku != null) {
      return '$productName ($variantSku)';
    }
    if (productName != null) return productName!;
    if (variantSku != null) return variantSku!;
    if (categoryName != null) return categoryName!;
    return periodLabel;
  }
}

class StockMovementReportEntity {
  final String period;
  final int? categoryId;
  final List<StockMovementReportBucket> buckets;
  final int totalQtyIn;
  final int totalQtyOut;
  final int totalNetChange;
  final double totalValueIn;
  final double totalValueOut;
  final double totalNetValue;
  final double? totalClosingStockValue;

  const StockMovementReportEntity({
    required this.period,
    this.categoryId,
    required this.buckets,
    required this.totalQtyIn,
    required this.totalQtyOut,
    required this.totalNetChange,
    required this.totalValueIn,
    required this.totalValueOut,
    required this.totalNetValue,
    this.totalClosingStockValue,
  });
}

class StockMovementTrendPoint {
  final String label;
  final int qtyIn;
  final int qtyOut;

  const StockMovementTrendPoint({
    required this.label,
    required this.qtyIn,
    required this.qtyOut,
  });

  static List<StockMovementTrendPoint> fromBuckets(
    List<StockMovementReportBucket> buckets,
  ) {
    return buckets
        .map(
          (b) => StockMovementTrendPoint(
            label: b.periodLabel,
            qtyIn: b.qtyIn,
            qtyOut: b.qtyOut,
          ),
        )
        .toList();
  }
}
