import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_price_tier.dart';

class QuotationPriceTierModel extends QuotationPriceTierEntity {
  const QuotationPriceTierModel({
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    super.unitLabel = 'Pcs',
  });

  factory QuotationPriceTierModel.fromJson(Map<String, dynamic> json) {
    return QuotationPriceTierModel(
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: double.tryParse('${json['unit_price']}') ?? 0,
      totalPrice: double.tryParse('${json['total_price']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson(int sortOrder) {
    return {
      'quantity': quantity,
      'unit_price': unitPrice,
      'sort_order': sortOrder,
    };
  }
}

List<Map<String, dynamic>> quotationPriceTiersToJson(
  List<QuotationPriceTierEntity> tiers,
) {
  return [
    for (var i = 0; i < tiers.length; i++)
      QuotationPriceTierModel(
        quantity: tiers[i].quantity,
        unitPrice: tiers[i].unitPrice,
        totalPrice: tiers[i].totalPrice,
        unitLabel: tiers[i].unitLabel,
      ).toJson(i),
  ];
}
