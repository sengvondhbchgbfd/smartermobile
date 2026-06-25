import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/stock_movement_model.dart';

abstract class StockMovementRemoteDataSource {
  Future<List<StockMovementModel>> getAll({int? variantId}); // ✅
  Future<StockMovementModel> getById(int movementId);
  Future<StockMovementModel> create({
    required int variantId,
    required int productId, // ✅
    required int qtyIn,
    required int qtyOut,
    required String movementType, // ✅
    required DateTime date, // ✅
  });
  Future<void> delete(int movementId);
}

class StockMovementRemoteDataSourceImpl
    implements StockMovementRemoteDataSource {
  final DioClient _dioClient;
  StockMovementRemoteDataSourceImpl(this._dioClient);
  Dio get _dio => _dioClient.dio;

  Never _throw(DioException e) {
    final detail = e.response?.data;
    final message = detail is Map
        ? (detail['detail'] ?? e.message ?? 'Error').toString()
        : e.message ?? 'Error';
    throw ApiException(
      statusCode: e.response?.statusCode ?? 0,
      message: message,
    );
  }

  @override
  Future<List<StockMovementModel>> getAll({int? variantId}) async {
    try {
      final res = await _dio.get(
        ApiEndpoints.stockMovements,
        queryParameters: {
          if (variantId != null) 'variant_id': variantId, // ✅
        },
      );
      return (res.data as List)
          .map((e) => StockMovementModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<StockMovementModel> getById(int movementId) async {
    try {
      return StockMovementModel.fromJson(
        (await _dio.get(ApiEndpoints.stockMovementById(movementId))).data,
      );
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<StockMovementModel> create({
    required int variantId, // ✅
    required int productId, // ✅
    required int qtyIn,
    required int qtyOut,
    required String movementType, // ✅
    required DateTime date, // ✅
  }) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.stockMovements,
        data: {
          'variant_id': variantId, // ✅
          'product_id': productId,
          'qty_in': qtyIn,
          'qty_out': qtyOut,
          'movement_type': movementType, // ✅
          'date':
              '${date.year}-'
              '${date.month.toString().padLeft(2, '0')}-'
              '${date.day.toString().padLeft(2, '0')}',
        },
      );
      return StockMovementModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> delete(int movementId) async {
    try {
      await _dio.delete(ApiEndpoints.stockMovementById(movementId));
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
