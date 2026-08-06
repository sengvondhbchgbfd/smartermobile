import '../../domain/entities/quotation_item_entity.dart';

class QuotationItemModel extends QuotationItemEntity {
  const QuotationItemModel({
    required super.itemId,
    required super.quotationId,
    required super.sortOrder,
    required super.itemName,
    super.size,
    super.pages,
    super.printSide,
    super.colorSpec,
    super.paperCover,
    super.paperInside,
    super.finishing,
    super.language,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    super.note,
  });

  factory QuotationItemModel.fromJson(Map<String, dynamic> json) {
    return QuotationItemModel(
      itemId: json['item_id'] as int,
      quotationId: json['quotation_id'] as int,
      sortOrder: json['sort_order'] as int? ?? 0,
      itemName: json['item_name'] as String? ?? '',
      size: json['size'] as String?,
      pages: json['pages'] as int?,
      printSide: json['print_side'] as String?,
      colorSpec: json['color_spec'] as String?,
      paperCover: json['paper_cover'] as String?,
      paperInside: json['paper_inside'] as String?,
      finishing: json['finishing'] as String?,
      language: json['language'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: double.tryParse('${json['unit_price']}') ?? 0,
      totalPrice: double.tryParse('${json['total_price']}') ?? 0,
      note: json['note'] as String?,
    );
  }

  /// Payload for create/update requests.
  Map<String, dynamic> toJson() {
    return {
      'sort_order': sortOrder,
      'item_name': itemName,
      if (size != null) 'size': size,
      if (pages != null) 'pages': pages,
      if (printSide != null) 'print_side': printSide,
      if (colorSpec != null) 'color_spec': colorSpec,
      if (paperCover != null) 'paper_cover': paperCover,
      if (paperInside != null) 'paper_inside': paperInside,
      if (finishing != null) 'finishing': finishing,
      if (language != null) 'language': language,
      'quantity': quantity,
      'unit_price': unitPrice,
      if (note != null) 'note': note,
    };
  }
}
