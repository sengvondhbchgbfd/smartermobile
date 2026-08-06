import '../../domain/entities/quotation_entity.dart';
import '../../domain/entities/quotation_enums.dart';
import 'quotation_item_model.dart';

class QuotationModel extends QuotationEntity {
  const QuotationModel({
    required super.quotationId,
    required super.invoiceId,
    required super.companyId,
    super.customerId,
    super.staffId,
    required super.refNumber,
    required super.quotationDate,
    super.expiryDate,
    super.productionDays,
    super.artworkStatus,
    super.paymentTerms,
    super.deliveryMethod,
    required super.subtotal,
    required super.discount,
    required super.tax,
    required super.totalAmount,
    super.note,
    required super.status,
    super.createdBy,
    super.createdAt,
    super.updatedAt,
    super.items,
    super.customerName,
    super.customerPhone,
    super.staffName,
  });

  factory QuotationModel.fromJson(Map<String, dynamic> json) {
    return QuotationModel(
      quotationId: json['quotation_id'] as int,
      invoiceId: json['invoice_id'] as int?,

      companyId: json['company_id'] as int? ?? 0,
      customerId: json['customer_id'] as int?,
      staffId: json['staff_id'] as int?,
      refNumber: json['ref_number'] as String? ?? '',
      quotationDate: DateTime.parse(json['quotation_date'] as String),
      expiryDate: json['expiry_date'] != null
          ? DateTime.tryParse(json['expiry_date'] as String)
          : null,
      productionDays: json['production_days'] as int?,
      artworkStatus: json['artwork_status'] != null
          ? ArtworkStatusX.fromApi(json['artwork_status'] as String?)
          : null,
      paymentTerms: json['payment_terms'] as String?,
      deliveryMethod: json['delivery_method'] != null
          ? DeliveryMethodX.fromApi(json['delivery_method'] as String?)
          : null,
      subtotal: double.tryParse('${json['subtotal']}') ?? 0,
      discount: double.tryParse('${json['discount']}') ?? 0,
      tax: double.tryParse('${json['tax']}') ?? 0,
      totalAmount: double.tryParse('${json['total_amount']}') ?? 0,
      note: json['note'] as String?,
      status: QuotationStatusX.fromApi(json['status'] as String?),
      createdBy: json['created_by'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => QuotationItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      staffName: json['staff_name'] as String?,
    );
  }

  /// Payload for POST /quotations (create).
  static Map<String, dynamic> createPayload({
    required int customerId,
    int? staffId,
    required String refNumber,
    required DateTime quotationDate,
    DateTime? expiryDate,
    int? productionDays,
    ArtworkStatus? artworkStatus,
    String? paymentTerms,
    DeliveryMethod? deliveryMethod,
    required double discount,
    required double tax,
    String? note,
    required List<QuotationItemModel> items,
  }) {
    return {
      'customer_id': customerId,
      if (staffId != null) 'staff_id': staffId,
      'ref_number': refNumber,
      'quotation_date': _dateOnly(quotationDate),
      if (expiryDate != null) 'expiry_date': _dateOnly(expiryDate),
      if (productionDays != null) 'production_days': productionDays,
      if (artworkStatus != null) 'artwork_status': artworkStatus.apiValue,
      if (paymentTerms != null) 'payment_terms': paymentTerms,
      if (deliveryMethod != null) 'delivery_method': deliveryMethod.apiValue,
      'discount': discount,
      'tax': tax,
      if (note != null) 'note': note,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  /// Payload for PATCH /quotations/{id} (partial update).
  Map<String, dynamic> toUpdateJson({
    int? customerId,
    int? staffId,
    String? refNumber,
    DateTime? quotationDate,
    DateTime? expiryDate,
    int? productionDays,
    ArtworkStatus? artworkStatus,
    String? paymentTerms,
    DeliveryMethod? deliveryMethod,
    double? discount,
    double? tax,
    String? note,
  }) {
    final data = <String, dynamic>{};
    if (customerId != null) data['customer_id'] = customerId;
    if (staffId != null) data['staff_id'] = staffId;
    if (refNumber != null) data['ref_number'] = refNumber;
    if (quotationDate != null) {
      data['quotation_date'] = _dateOnly(quotationDate);
    }
    if (expiryDate != null) data['expiry_date'] = _dateOnly(expiryDate);
    if (productionDays != null) data['production_days'] = productionDays;
    if (artworkStatus != null) {
      data['artwork_status'] = artworkStatus.apiValue;
    }
    if (paymentTerms != null) data['payment_terms'] = paymentTerms;
    if (deliveryMethod != null) {
      data['delivery_method'] = deliveryMethod.apiValue;
    }
    if (discount != null) data['discount'] = discount;
    if (tax != null) data['tax'] = tax;
    if (note != null) data['note'] = note;
    return data;
  }

  static String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
