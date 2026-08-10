import '../../domain/entities/quotation_entity.dart';
import '../../domain/entities/quotation_item_entity.dart';
import '../../domain/entities/quotation_price_tier.dart';
import '../../domain/entities/quotation_enums.dart';
import '../../domain/repositories/quotation_repository.dart';
import '../datasources/quotation_remote_datasource.dart';
import '../models/quotation_model.dart';
import '../models/quotation_item_model.dart';
import '../models/quotation_price_tier_model.dart';

//////////////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////////////
class QuotationRepositoryImpl implements QuotationRepository {
  final QuotationRemoteDataSource remote;
  QuotationRepositoryImpl(this.remote);
  @override
  Future<List<QuotationEntity>> getAll({
    int? staffId,
    int? customerId,
    QuotationStatus? status,
  }) {
    return remote.getAll(
      staffId: staffId,
      customerId: customerId,
      status: status?.apiValue,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<QuotationEntity>> getMyQuotations() => remote.getMyQuotations();

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<QuotationEntity>> getByStaff(int staffId) =>
      remote.getByStaff(staffId);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationEntity> getById(int quotationId) =>
      remote.getById(quotationId);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Future<Map<String, dynamic>> getSummary() => remote.getSummary();
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
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
    final itemModels = items
        .map(
          (e) => QuotationItemModel(
            itemId: 0,
            quotationId: 0,
            sortOrder: e.sortOrder,
            itemName: e.itemName,
            size: e.size,
            pages: e.pages,
            printSide: e.printSide,
            colorSpec: e.colorSpec,
            paperCover: e.paperCover,
            paperInside: e.paperInside,
            finishing: e.finishing,
            language: e.language,
            quantity: e.quantity,
            unitPrice: e.unitPrice,
            totalPrice: e.totalPrice,
            note: e.note,
            priceTiers: e.priceTiers, // ← added: carry tiers through on create
          ),
        )
        .toList();

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final payload = QuotationModel.createPayload(
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
      items: itemModels,
    );

    return remote.create(payload);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
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
    final payload = <String, dynamic>{};
    if (customerId != null) payload['customer_id'] = customerId;
    if (staffId != null) payload['staff_id'] = staffId;
    if (refNumber != null) payload['ref_number'] = refNumber;
    if (quotationDate != null) {
      payload['quotation_date'] = _dateOnly(quotationDate);
    }
    if (expiryDate != null) payload['expiry_date'] = _dateOnly(expiryDate);
    if (productionDays != null) payload['production_days'] = productionDays;
    if (artworkStatus != null) {
      payload['artwork_status'] = artworkStatus.apiValue;
    }
    if (paymentTerms != null) payload['payment_terms'] = paymentTerms;
    if (deliveryMethod != null) {
      payload['delivery_method'] = deliveryMethod.apiValue;
    }
    if (discount != null) payload['discount'] = discount;
    if (tax != null) payload['tax'] = tax;
    if (note != null) payload['note'] = note;

    return remote.update(quotationId, payload);
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationEntity> updateStatus(
    int quotationId,
    QuotationStatus status, {
    String? note,
  }) {
    return remote.updateStatus(quotationId, status.apiValue, note: note);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> delete(int quotationId) => remote.delete(quotationId);

  //////////////////////////////////////////////////////////////////////////////
  /// Add item — priceTiers included when non-null.
  //////////////////////////////////////////////////////////////////////////////

  @override
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
    List<QuotationPriceTierEntity>? priceTiers, // ← added
  }) {
    return remote.addItem(quotationId, {
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
      if (priceTiers != null) // ← added
        'price_tiers': quotationPriceTiersToJson(priceTiers),
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Update item — priceTiers: omitted key = don't touch, [] = clear all,
  /// non-empty = replace-all.
  //////////////////////////////////////////////////////////////////////////////

  @override
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
    List<QuotationPriceTierEntity>? priceTiers, // ← added
  }) {
    final payload = <String, dynamic>{};
    if (sortOrder != null) payload['sort_order'] = sortOrder;
    if (itemName != null) payload['item_name'] = itemName;
    if (size != null) payload['size'] = size;
    if (pages != null) payload['pages'] = pages;
    if (printSide != null) payload['print_side'] = printSide;
    if (colorSpec != null) payload['color_spec'] = colorSpec;
    if (paperCover != null) payload['paper_cover'] = paperCover;
    if (paperInside != null) payload['paper_inside'] = paperInside;
    if (finishing != null) payload['finishing'] = finishing;
    if (language != null) payload['language'] = language;
    if (quantity != null) payload['quantity'] = quantity;
    if (unitPrice != null) payload['unit_price'] = unitPrice;
    if (note != null) payload['note'] = note;
    if (priceTiers != null) {
      // ← added
      payload['price_tiers'] = quotationPriceTiersToJson(priceTiers);
    }

    return remote.updateItem(quotationId, itemId, payload);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> deleteItem(int quotationId, int itemId) =>
      remote.deleteItem(quotationId, itemId);

  static String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
