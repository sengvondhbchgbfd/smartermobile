import '../entities/quotation_entity.dart';
import '../entities/quotation_item_entity.dart';
import '../entities/quotation_price_tier.dart';
import '../entities/quotation_enums.dart';
import '../repositories/quotation_repository.dart';

class QuotationUsecase {
  final QuotationRepository repository;
  QuotationUsecase(this.repository);

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<QuotationEntity>> getAll({
    int? staffId,
    int? customerId,
    QuotationStatus? status,
  }) {
    return repository.getAll(
      staffId: staffId,
      customerId: customerId,
      status: status,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<List<QuotationEntity>> getMyQuotations() =>
      repository.getMyQuotations();

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<List<QuotationEntity>> getByStaff(int staffId) =>
      repository.getByStaff(staffId);

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> getById(int quotationId) =>
      repository.getById(quotationId);

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<Map<String, dynamic>> getSummary() => repository.getSummary();

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> create({
    required int customerId,
    int? staffId,
    required String refNumber,
    required DateTime quotationDate,
    required DateTime expiryDate,
    required int productionDays,
    required ArtworkStatus artworkStatus,
    String? paymentTerms,
    required DeliveryMethod deliveryMethod,
    required double discount,
    required double tax,
    String? note,
    List<QuotationItemEntity> items = const [],
  }) {
    return repository.create(
      customerId: customerId,
      staffId: staffId,
      refNumber: refNumber,
      quotationDate: quotationDate,
      expiryDate: expiryDate,
      productionDays: productionDays,
      artworkStatus: artworkStatus,
      paymentTerms: paymentTerms,
      deliveryMethod: deliveryMethod,
      discount: discount,
      tax: tax,
      note: note,
      items: items,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> update(
    int quotationId, {
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
    return repository.update(
      quotationId,
      customerId: customerId,
      staffId: staffId,
      refNumber: refNumber,
      quotationDate: quotationDate,
      expiryDate: expiryDate,
      productionDays: productionDays,
      artworkStatus: artworkStatus,
      paymentTerms: paymentTerms,
      deliveryMethod: deliveryMethod,
      discount: discount,
      tax: tax,
      note: note,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> updateStatus(
    int quotationId,
    QuotationStatus status, {
    String? note,
  }) {
    return repository.updateStatus(quotationId, status, note: note);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> delete(int quotationId) => repository.delete(quotationId);

  //////////////////////////////////////////////////////////////////////////////
  /// Add item — now accepts optional priceTiers
  //////////////////////////////////////////////////////////////////////////////
  Future<QuotationItemEntity> addItem(
    int quotationId, {
    required int sortOrder,
    required String itemName,
    String? size,
    int? pages,
    String? printSide,
    String? colorSpec,
    String? paperCover,
    String? paperInside,
    String? finishing,
    String? language,
    required int quantity,
    required double unitPrice,
    String? note,
    List<QuotationPriceTierEntity>? priceTiers,   // ← added
  }) {
    return repository.addItem(
      quotationId,
      sortOrder: sortOrder,
      itemName: itemName,
      size: size,
      pages: pages,
      printSide: printSide,
      colorSpec: colorSpec,
      paperCover: paperCover,
      paperInside: paperInside,
      finishing: finishing,
      language: language,
      quantity: quantity,
      unitPrice: unitPrice,
      note: note,
      priceTiers: priceTiers,                     // ← added
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Update item — now accepts optional priceTiers.
  /// null = don't touch tiers. [] = clear all tiers. Non-empty = replace-all.
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationItemEntity> updateItem(
    int quotationId,
    int itemId, {
    int? sortOrder,
    String? itemName,
    String? size,
    int? pages,
    String? printSide,
    String? colorSpec,
    String? paperCover,
    String? paperInside,
    String? finishing,
    String? language,
    int? quantity,
    double? unitPrice,
    String? note,
    List<QuotationPriceTierEntity>? priceTiers,   // ← added
  }) {
    return repository.updateItem(
      quotationId,
      itemId,
      sortOrder: sortOrder,
      itemName: itemName,
      size: size,
      pages: pages,
      printSide: printSide,
      colorSpec: colorSpec,
      paperCover: paperCover,
      paperInside: paperInside,
      finishing: finishing,
      language: language,
      quantity: quantity,
      unitPrice: unitPrice,
      note: note,
      priceTiers: priceTiers,                     
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> deleteItem(int quotationId, int itemId) =>
      repository.deleteItem(quotationId, itemId);
}