enum PaymentType {
  cash,
  card,
  transfer,
  other;

  static PaymentType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'cash':
        return PaymentType.cash;
      case 'card':
        return PaymentType.card;
      case 'transfer':
        return PaymentType.transfer;
      default:
        return PaymentType.other;
    }
  }

  String get value {
    switch (this) {
      case PaymentType.cash:
        return 'cash';
      case PaymentType.card:
        return 'card';
      case PaymentType.transfer:
        return 'transfer';
      case PaymentType.other:
        return 'other';
    }
  }
}

// ── InvoiceItem ──────────────────────────────────────────────
class InvoiceItemEntity {
  final int itemId;
  final int invoiceId;
  final int companyId;
  final int? productId;
  final int? variantId;
  final String? itemName;
  final String? size;
  final int? pages;
  final String? printSide;
  final String? colorSpec;
  final String? paperCover;
  final String? paperInside;
  final String? finishing;
  final int quantity;
  final double unitPrice;
  final double? totalPrice;

  const InvoiceItemEntity({
    required this.itemId,
    required this.invoiceId,
    required this.companyId,
    this.productId,
    this.variantId,
    this.itemName,
    this.size,
    this.pages,
    this.printSide,
    this.colorSpec,
    this.paperCover,
    this.paperInside,
    this.finishing,
    required this.quantity,
    required this.unitPrice,
    this.totalPrice,
  });
  bool get isInventoryItem => productId != null && variantId != null;
}

// ── InvoiceAttachment ────────────────────────────────────────
class InvoiceAttachmentEntity {
  final int attachmentId;
  final int companyId;
  final int invoiceId;
  final String fileUrl;
  final String? publicId;
  final String? fileName;
  final String? fileType;
  final DateTime createdAt;

  const InvoiceAttachmentEntity({
    required this.attachmentId,
    required this.companyId,
    required this.invoiceId,
    required this.fileUrl,
    this.publicId,
    this.fileName,
    this.fileType,
    required this.createdAt,
  });
}

// ── Invoice ──────────────────────────────────────────────────
class InvoiceEntity {
  final int invoiceId;
  final int companyId;
  final int? customerId;
  final int? staffId;
  final double? totalAmount;
  final double discount;
  final double tax;
  final PaymentType? paymentType;
  final List<InvoiceItemEntity> items;
  final List<InvoiceAttachmentEntity> attachments;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const InvoiceEntity({
    required this.invoiceId,
    required this.companyId,
    this.customerId,
    this.staffId,
    this.totalAmount,
    this.discount = 0.0,
    this.tax = 0.0,
    this.paymentType,
    this.items = const [],
    this.attachments = const [],
    required this.createdAt,
    this.updatedAt,
  });
}
