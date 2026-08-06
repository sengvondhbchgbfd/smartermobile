import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/quotation_entity.dart';
import '../../domain/entities/quotation_enums.dart';
import '../../domain/entities/quotation_item_entity.dart';
import 'quotation_provider.dart';

part 'quotation_form_provider.g.dart';

class QuotationFormData {
  final int? customerId;
  final int? staffId;
  final String refNumber;
  final DateTime quotationDate;
  final DateTime expiryDate;
  final int productionDays;
  final ArtworkStatus artworkStatus;
  final String paymentTerms;
  final DeliveryMethod deliveryMethod;
  final double discount;
  final double tax;
  final String note;
  final List<QuotationItemEntity> items;

  const QuotationFormData({
    this.customerId,
    this.staffId,
    this.refNumber = '',
    required this.quotationDate,
    required this.expiryDate,
    this.productionDays = 1,
    this.artworkStatus = ArtworkStatus.notProvided,
    this.paymentTerms = '',
    this.deliveryMethod = DeliveryMethod.pickup,
    this.discount = 0,
    this.tax = 0,
    this.note = '',
    this.items = const [],
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  double get totalAmount => subtotal - discount + tax;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  bool get isValid =>
      customerId != null && refNumber.trim().isNotEmpty && items.isNotEmpty;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  factory QuotationFormData.fromEntity(QuotationEntity q) {
    return QuotationFormData(
      customerId: q.customerId ?? 0,
      staffId: q.staffId,
      refNumber: q.refNumber,
      quotationDate: q.quotationDate,
      expiryDate: q.expiryDate ?? DateTime.now().add(const Duration(days: 30)),
      productionDays: q.productionDays ?? 0,
      artworkStatus: q.artworkStatus ?? ArtworkStatus.notProvided,
      paymentTerms: q.paymentTerms ?? '',
      deliveryMethod: q.deliveryMethod ?? DeliveryMethod.pickup,
      discount: q.discount,
      tax: q.tax,
      note: q.note ?? '',
      items: q.items,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  QuotationFormData copyWith({
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
    List<QuotationItemEntity>? items,
  }) {
    return QuotationFormData(
      customerId: customerId ?? this.customerId,
      staffId: staffId ?? this.staffId,
      refNumber: refNumber ?? this.refNumber,
      quotationDate: quotationDate ?? this.quotationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      productionDays: productionDays ?? this.productionDays,
      artworkStatus: artworkStatus ?? this.artworkStatus,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      note: note ?? this.note,
      items: items ?? this.items,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

@riverpod
class QuotationFormNotifier extends _$QuotationFormNotifier {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  QuotationFormData build({QuotationEntity? initial}) {
    if (initial != null) return QuotationFormData.fromEntity(initial);
    final now = DateTime.now();
    return QuotationFormData(
      quotationDate: now,
      expiryDate: now.add(const Duration(days: 14)),
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setCustomer(int customerId) {
    state = state.copyWith(customerId: customerId);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setStaff(int? staffId) {
    state = state.copyWith(staffId: staffId);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setRefNumber(String value) => state = state.copyWith(refNumber: value);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setQuotationDate(DateTime date) {
    state = state.copyWith(quotationDate: date);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setExpiryDate(DateTime date) => state = state.copyWith(expiryDate: date);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void setProductionDays(int days) {
    state = state.copyWith(productionDays: days);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setArtworkStatus(ArtworkStatus status) {
    state = state.copyWith(artworkStatus: status);
  }


  
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setPaymentTerms(String value) {
    state = state.copyWith(paymentTerms: value);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setDeliveryMethod(DeliveryMethod method) {
    state = state.copyWith(deliveryMethod: method);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void setDiscount(double value) => state = state.copyWith(discount: value);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void setTax(double value) => state = state.copyWith(tax: value);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void setNote(String value) => state = state.copyWith(note: value);

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  // -- local item list (only used before the quotation is created) --------

  void addLocalItem(QuotationItemEntity item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void removeLocalItem(int index) {
    final updated = [...state.items]..removeAt(index);
    state = state.copyWith(items: updated);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void updateLocalItem(int index, QuotationItemEntity item) {
    final updated = [...state.items];
    updated[index] = item;
    state = state.copyWith(items: updated);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> submitCreate() async {
    final usecase = await ref.read(quotationUsecaseProvider.future);
    final data = state;
    final created = await usecase.create(
      customerId: data.customerId!,
      staffId: data.staffId,
      refNumber: data.refNumber.trim(),
      quotationDate: data.quotationDate,
      expiryDate: data.expiryDate,
      productionDays: data.productionDays,
      artworkStatus: data.artworkStatus,
      paymentTerms: data.paymentTerms.trim().isEmpty
          ? null
          : data.paymentTerms.trim(),
      deliveryMethod: data.deliveryMethod,
      discount: data.discount,
      tax: data.tax,
      note: data.note.trim().isEmpty ? null : data.note.trim(),
      items: data.items,
    );
    ref.invalidate(quotationListNotifierProvider);
    return created;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> submitUpdate(int quotationId) async {
    final usecase = await ref.read(quotationUsecaseProvider.future);
    final data = state;
    final updated = await usecase.update(
      quotationId,
      customerId: data.customerId,
      staffId: data.staffId,
      refNumber: data.refNumber.trim(),
      quotationDate: data.quotationDate,
      expiryDate: data.expiryDate,
      productionDays: data.productionDays,
      artworkStatus: data.artworkStatus,
      paymentTerms: data.paymentTerms.trim().isEmpty
          ? null
          : data.paymentTerms.trim(),
      deliveryMethod: data.deliveryMethod,
      discount: data.discount,
      tax: data.tax,
      note: data.note.trim().isEmpty ? null : data.note.trim(),
    );
    ref.invalidate(quotationListNotifierProvider);
    ref.invalidate(quotationDetailNotifierProvider(quotationId));
    return updated;
  }
}
