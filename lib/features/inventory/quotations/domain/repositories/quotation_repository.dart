import '../entities/quotation_entity.dart';
import '../entities/quotation_item_entity.dart';
import '../entities/quotation_enums.dart';

abstract class QuotationRepository {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<List<QuotationEntity>> getAll({
    int? staffId,
    int? customerId,
    QuotationStatus? status,
  });
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<List<QuotationEntity>> getMyQuotations();
  Future<List<QuotationEntity>> getByStaff(int staffId);
  Future<QuotationEntity> getById(int quotationId);
  Future<Map<String, dynamic>> getSummary();

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
  });

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
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<QuotationEntity> updateStatus(
    int quotationId,
    QuotationStatus status, {
    String? note,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> delete(int quotationId);
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
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
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
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> deleteItem(int quotationId, int itemId);
}
