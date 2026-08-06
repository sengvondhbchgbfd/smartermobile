import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_price_tier.dart';

class QuotationItemEntity {
  final int itemId;
  final int quotationId;
  final int sortOrder;
  final String itemName;
  final String? size;
  final int? pages;
  final String? printSide;
  final String? colorSpec;
  final String? paperCover;
  final String? paperInside;
  final String? finishing;
  final String? language;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? note;

  final List<QuotationPriceTierEntity>? priceTiers;

  const QuotationItemEntity({
    required this.itemId,
    required this.quotationId,
    required this.sortOrder,
    required this.itemName,
    this.size,
    this.pages,
    this.printSide,
    this.colorSpec,
    this.paperCover,
    this.paperInside,
    this.finishing,
    this.language,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.note,
    this.priceTiers,
  });
}
