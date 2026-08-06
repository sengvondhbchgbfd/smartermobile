import '../../domain/entities/stock_movement_report_entity.dart';

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

double? _toDoubleOrNull(dynamic v) {
  if (v == null) return null;
  return _toDouble(v);
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

int? _toIntOrNull(dynamic v) {
  if (v == null) return null;
  return _toInt(v);
}

class StockMovementReportBucketModel extends StockMovementReportBucket {
  const StockMovementReportBucketModel({
    required super.periodLabel,
    super.categoryId,
    super.categoryName,
    super.productId,
    super.productName,
    super.productDescription,
    super.variantId,
    super.variantSku,
    super.variantSpecs,
    super.price,
    required super.qtyIn,
    required super.qtyOut,
    required super.netChange,
    required super.movementCount,
    required super.valueIn,
    required super.valueOut,
    required super.netValue,
    super.openingBalance,
    super.closingBalance,
    super.closingStockValue,
  });

  factory StockMovementReportBucketModel.fromJson(Map<String, dynamic> json) {
    return StockMovementReportBucketModel(
      periodLabel: (json['period_label'] as String?) ?? 'All time',
      categoryId: _toIntOrNull(json['category_id']),
      categoryName: json['category_name'] as String?,
      productId: _toIntOrNull(json['product_id']),
      productName: json['product_name'] as String?,
      productDescription: json['product_description'] as String?,
      variantId: _toIntOrNull(json['variant_id']),
      variantSku: json['variant_sku'] as String?,
      variantSpecs:
          (json['variant_specs'] as Map?)?.cast<String, dynamic>() ?? const {},
      price: json['price'] == null ? null : _toDouble(json['price']),
      qtyIn: _toInt(json['qty_in']),
      qtyOut: _toInt(json['qty_out']),
      netChange: _toInt(json['net_change']),
      movementCount: _toInt(json['movement_count']),
      valueIn: _toDouble(json['value_in']),
      valueOut: _toDouble(json['value_out']),
      netValue: _toDouble(json['net_value']),
      openingBalance: _toIntOrNull(json['opening_balance']),
      closingBalance: _toIntOrNull(json['closing_balance']),
      closingStockValue: _toDoubleOrNull(json['closing_stock_value']),
    );
  }
}

class StockMovementReportResponse extends StockMovementReportEntity {
  const StockMovementReportResponse({
    required super.period,
    super.categoryId,
    required super.buckets,
    required super.totalQtyIn,
    required super.totalQtyOut,
    required super.totalNetChange,
    required super.totalValueIn,
    required super.totalValueOut,
    required super.totalNetValue,
    super.totalClosingStockValue,
  });

  factory StockMovementReportResponse.fromJson(Map<String, dynamic> json) {
    return StockMovementReportResponse(
      period: json['period'] as String,
      categoryId: _toIntOrNull(json['category_id']),
      buckets: (json['buckets'] as List? ?? [])
          .map(
            (e) => StockMovementReportBucketModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalQtyIn: _toInt(json['total_qty_in']),
      totalQtyOut: _toInt(json['total_qty_out']),
      totalNetChange: _toInt(json['total_net_change']),
      totalValueIn: _toDouble(json['total_value_in']),
      totalValueOut: _toDouble(json['total_value_out']),
      totalNetValue: _toDouble(json['total_net_value']),
      totalClosingStockValue: _toDoubleOrNull(
        json['total_closing_stock_value'],
      ),
    );
  }
}
