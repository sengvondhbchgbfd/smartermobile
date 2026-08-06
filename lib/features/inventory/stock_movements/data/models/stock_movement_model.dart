import '../../domain/entities/stock_movement_entity.dart';

class StockMovementModel extends StockMovementEntity {
  const StockMovementModel({
    required super.movementId,
    required super.companyId,
    required super.variantId,
    required super.qtyIn,
    required super.qtyOut,
    required super.openingBalance,
    required super.balanceQuantity,
    super.movementType,
    required super.date,
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> j) =>
      StockMovementModel(
        movementId: j['movement_id'] as int,
        companyId: j['company_id'] as int,
        variantId: j['variant_id'] as int,
        qtyIn: j['qty_in'] as int? ?? 0,
        qtyOut: j['qty_out'] as int? ?? 0,

        openingBalance:  int.tryParse(j['opening_balance'].toString()) ?? 0, 
        balanceQuantity: int.tryParse(j['balance_quantity'].toString()) ?? 0,
        movementType: j['movement_type'] as String?,
        // ✅ Bug 5 fix: removed note
        date: DateTime.parse(j['date'] as String),
      );
}
