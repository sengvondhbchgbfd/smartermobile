class QuotationPriceTierEntity {
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String unitLabel;

  const QuotationPriceTierEntity({
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.unitLabel = 'Pcs',
  });
}
