import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/features/inventory/quotations/data/models/quotation_item_model.dart';
import 'package:frontendmobile/features/inventory/quotations/data/models/quotation_model.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
abstract class QuotationRemoteDataSource {
  Future<List<QuotationModel>> getAll({
    int? staffId,
    int? customerId,
    String? status,
  });

  Future<List<QuotationModel>> getMyQuotations();
  Future<List<QuotationModel>> getByStaff(int staffId);
  Future<QuotationModel> getById(int quotationId);
  Future<Map<String, dynamic>> getSummary();
  Future<QuotationModel> create(Map<String, dynamic> payload);
  Future<QuotationModel> update(int quotationId, Map<String, dynamic> payload);
  Future<QuotationModel> updateStatus(
    int quotationId,
    String status, {
    String? note,
  });
  Future<void> delete(int quotationId);

  Future<List<QuotationItemModel>> getItems(int quotationId);
  Future<QuotationItemModel> addItem(
    int quotationId,
    Map<String, dynamic> payload,
  );
  Future<QuotationItemModel> updateItem(
    int quotationId,
    int itemId,
    Map<String, dynamic> payload,
  );
  Future<void> deleteItem(int quotationId, int itemId);
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class QuotationRemoteDataSourceImpl implements QuotationRemoteDataSource {
  final Dio dio;

  QuotationRemoteDataSourceImpl(this.dio);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  Future<List<QuotationModel>> getAll({
    int? staffId,
    int? customerId,
    String? status,
  }) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.quotations}/',
        queryParameters: {
          if (staffId != null) 'staff_id': staffId,
          if (customerId != null) 'customer_id': customerId,
          if (status != null) 'quo_status': status,
        },
      );
      return (response.data as List)
          .map((e) => QuotationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<QuotationModel>> getMyQuotations() async {
    try {
      final response = await dio.get('${ApiEndpoints.quotations}/my');
      return (response.data as List)
          .map((e) => QuotationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<QuotationModel>> getByStaff(int staffId) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.quotations}/staff/$staffId',
      );
      return (response.data as List)
          .map((e) => QuotationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationModel> getById(int quotationId) async {
    try {
      final response = await dio.get('${ApiEndpoints.quotations}/$quotationId');
      return QuotationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>> getSummary() async {
    try {
      final response = await dio.get('${ApiEndpoints.quotations}/summary');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationModel> create(Map<String, dynamic> payload) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.quotations}/',
        data: payload,
      );
      return QuotationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationModel> update(
    int quotationId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.quotations}/$quotationId',
        data: payload,
      );
      return QuotationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationModel> updateStatus(
    int quotationId,
    String status, {
    String? note,
  }) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.quotations}/$quotationId/status',
        data: {'status': status, if (note != null) 'note': note},
      );
      return QuotationModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> delete(int quotationId) async {
    try {
      await dio.delete('${ApiEndpoints.quotations}/$quotationId');
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<QuotationItemModel>> getItems(int quotationId) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.quotations}/$quotationId/items',
      );
      return (response.data as List)
          .map((e) => QuotationItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationItemModel> addItem(
    int quotationId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.quotations}/$quotationId/items',
        data: payload,
      );
      return QuotationItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<QuotationItemModel> updateItem(
    int quotationId,
    int itemId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await dio.patch(
        '${ApiEndpoints.quotations}/$quotationId/items/$itemId',
        data: payload,
      );
      return QuotationItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> deleteItem(int quotationId, int itemId) async {
    try {
      await dio.delete('${ApiEndpoints.quotations}/$quotationId/items/$itemId');
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
}
