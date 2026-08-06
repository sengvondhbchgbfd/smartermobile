import 'dart:io';
import '../entities/invoice_entity.dart';

class InvoiceItemInput {
  final int productId;
  final int variantId;
  final int quantity;
  final double? unitPrice;
  const InvoiceItemInput({
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

abstract class InvoiceRepository {
  Future<List<InvoiceEntity>> getAll({int? customerId});
  Future<InvoiceEntity> getById(int invoiceId);

  Future<InvoiceEntity> create({
    int? customerId,
    int? staffId,
    required double totalAmount,
    required double discount,
    required double tax,
    required String paymentType,
    required List<InvoiceItemInput> items,
  });

 Future<InvoiceEntity> createFromQuotation({
    required int quotationId,
    required String paymentType,
  });

  Future<InvoiceEntity> update({
    required int invoiceId,
    double? totalAmount,
    double? discount,
    double? tax,
    String? paymentType,
  });

  Future<InvoiceAttachmentEntity> addAttachment({
    required int invoiceId,
    required File file,
    String? fileType,
  });

  Future<void> deleteAttachment({
    required int invoiceId,
    required int attachmentId,
  });

  Future<void> delete(int invoiceId);
}
