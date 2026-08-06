import 'package:frontendmobile/features/inventory/invoice/domain/entities/invoice_entity.dart';

double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0.0;


////////////////////////////////////////////////////////////////////////////////
// ── InvoiceItemModel ─────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class InvoiceItemModel extends InvoiceItemEntity {
  const InvoiceItemModel({
    required super.itemId,
    required super.invoiceId,
    required super.companyId,
    super.productId,
    super.variantId,
    super.itemName,
    super.size,
    super.pages,
    super.printSide,
    super.colorSpec,
    super.paperCover,
    super.paperInside,
    super.finishing,
    required super.quantity,
    required super.unitPrice,
    super.totalPrice,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> j) {
    return InvoiceItemModel(
      itemId: j['item_id'] as int,
      invoiceId: j['invoice_id'] as int,
      companyId: j['company_id'] as int,
      productId: j['product_id'] as int?,
      variantId: j['variant_id'] as int?,
      itemName: j['item_name'] as String?,
      size: j['size'] as String?,
      pages: j['pages'] as int?,
      printSide: j['print_side'] as String?,
      colorSpec: j['color_spec'] as String?,
      paperCover: j['paper_cover'] as String?,
      paperInside: j['paper_inside'] as String?,
      finishing: j['finishing'] as String?,
      quantity: j['quantity'] as int,
      unitPrice: _toDouble(j['unit_price']),
      totalPrice: j['total_price'] != null ? _toDouble(j['total_price']) : null,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// ── InvoiceAttachmentModel ───────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class InvoiceAttachmentModel extends InvoiceAttachmentEntity {
  const InvoiceAttachmentModel({
    required super.attachmentId,
    required super.companyId,
    required super.invoiceId,
    required super.fileUrl,
    super.publicId,
    super.fileName,
    super.fileType,
    required super.createdAt,
  });

  factory InvoiceAttachmentModel.fromJson(Map<String, dynamic> j) {
    return InvoiceAttachmentModel(
      attachmentId: j['attachment_id'] as int,
      companyId: j['company_id'] as int,
      invoiceId: j['invoice_id'] as int,
      fileUrl: j['file_url'] as String,
      publicId: j['public_id'] as String?,
      fileName: j['file_name'] as String?,
      fileType: j['file_type'] as String?,
      createdAt: DateTime.parse(j['created_at'] as String),
    );
  }
}


////////////////////////////////////////////////////////////////////////////////
// ── InvoiceModel ─────────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.invoiceId,
    required super.companyId,
    super.customerId,
    super.staffId,
    super.totalAmount,
    super.discount,
    super.tax,
    super.paymentType,
    super.items,
    super.attachments,
    required super.createdAt,
    super.updatedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> j) {
    return InvoiceModel(
      invoiceId: j['invoice_id'] as int,
      companyId: j['company_id'] as int,
      customerId: j['customer_id'] as int?,
      staffId: j['staff_id'] as int?,
      totalAmount: j['total_amount'] != null
          ? _toDouble(j['total_amount'])
          : null,
      discount: _toDouble(j['discount']),
      tax: _toDouble(j['tax']),
      paymentType: PaymentType.fromString(j['payment_type'] as String?),
      items: (j['items'] as List<dynamic>? ?? [])
          .map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachments: (j['attachments'] as List<dynamic>? ?? [])
          .map(
            (e) => InvoiceAttachmentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: DateTime.parse(j['created_at'] as String),
      updatedAt: j['updated_at'] != null
          ? DateTime.parse(j['updated_at'] as String)
          : null,
    );
  }
}
