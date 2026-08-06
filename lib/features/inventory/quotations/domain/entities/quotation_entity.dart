import 'quotation_enums.dart';
import 'quotation_item_entity.dart';

class QuotationEntity {
  final int quotationId;
  final int? invoiceId;
  final int companyId;
  final int? customerId;
  final int? staffId;
  final String refNumber;
  final DateTime quotationDate;
  final DateTime? expiryDate;
  final int? productionDays;
  final ArtworkStatus? artworkStatus;
  final String? paymentTerms;
  final DeliveryMethod? deliveryMethod;
  final double subtotal;
  final double discount;
  final double tax;
  final double totalAmount;
  final String? note;
  final QuotationStatus status;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<QuotationItemEntity> items;

  final String? customerName;
  final String? customerPhone;
  final String? staffName;

  const QuotationEntity({
    required this.quotationId,
    required this.invoiceId,
    required this.companyId,
    this.customerId,
    this.staffId,
    required this.refNumber,
    required this.quotationDate,
    this.expiryDate,
    this.productionDays,
    this.artworkStatus,
    this.paymentTerms,
    this.deliveryMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.totalAmount,
    this.note,
    required this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
    this.customerName,
    this.customerPhone,
    this.staffName,
  });

  bool get isEditable => status == QuotationStatus.draft;
  bool get isDeletable => status != QuotationStatus.accepted;
}
