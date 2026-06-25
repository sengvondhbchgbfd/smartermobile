class StockMovementEntity {
  final int movementId;
  final int companyId;
  final int variantId;
  final int qtyIn;
  final int qtyOut;
  final int openingBalance;
  final int balanceQuantity;
  final String? movementType;
  final DateTime date;

  const StockMovementEntity({
    required this.movementId,
    required this.companyId,
    required this.variantId,
    required this.qtyIn,
    required this.qtyOut,
    required this.openingBalance,
    required this.balanceQuantity,
    this.movementType,
    required this.date,
  });
}