import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/data/model/supplier_product_price_model.dart';

abstract class SupplierProductPriceRemoteDataSource {
  Future<List<SupplierProductPriceModel>> getAll({
    int? supplierId,
    int? variantId,
  });
  Future<SupplierProductPriceModel> getById(int priceId);

  Future<SupplierProductPriceModel> create({
    required int supplierId,
    required int variantId,
    required double unitPrice,
    String? note,
  });

  Future<SupplierProductPriceModel> update({
    required int priceId,
    double? unitPrice,
    String? note,
  });

  Future<void> delete(int priceId);
}

class SupplierProductPriceRemoteDataSourceImpl
    implements SupplierProductPriceRemoteDataSource {
  final DioClient _dioClient;
  SupplierProductPriceRemoteDataSourceImpl(this._dioClient);
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

  // 👈 new: single place that wraps EVERY failure mode, not just network ones
  Future<T> _safeCall<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      _throw(e);
    } catch (e) {
      throw ApiException(
        statusCode: 0,
        message: 'Unexpected error while processing response: $e',
      );
    }
  }

  @override
  Future<List<SupplierProductPriceModel>> getAll({
    int? supplierId,
    int? variantId,
  }) {
    return _safeCall(() async {
      final res = await _dio.get(
        ApiEndpoints.supplierPrices,
        queryParameters: {
          if (supplierId != null) 'supplier_id': supplierId,
          if (variantId != null) 'variant_id': variantId,
        },
      );
      return (res.data as List)
          .map((e) => SupplierProductPriceModel.fromJson(e))
          .toList();
    });
  }

  @override
  Future<SupplierProductPriceModel> getById(int priceId) {
    return _safeCall(() async {
      final res = await _dio.get(ApiEndpoints.supplierPriceById(priceId));
      return SupplierProductPriceModel.fromJson(res.data);
    });
  }

  @override
  Future<SupplierProductPriceModel> create({
    required int supplierId,
    required int variantId,
    required double unitPrice,
    String? note,
  }) {
    return _safeCall(() async {
      final res = await _dio.post(
        ApiEndpoints.supplierPrices,
        data: {
          'supplier_id': supplierId,
          'variant_id': variantId,
          'unit_price': unitPrice,
          if (note != null) 'note': note,
        },
      );
      return SupplierProductPriceModel.fromJson(res.data);
    });
  }

  @override
  Future<SupplierProductPriceModel> update({
    required int priceId,
    double? unitPrice,
    String? note,
  }) {
    return _safeCall(() async {
      final res = await _dio.patch(
        ApiEndpoints.supplierPriceById(priceId),
        data: {
          if (unitPrice != null) 'unit_price': unitPrice,
          if (note != null) 'note': note,
        },
      );
      return SupplierProductPriceModel.fromJson(res.data);
    });
  }

  @override
  Future<void> delete(int priceId) {
    return _safeCall(
      () => _dio.delete(ApiEndpoints.supplierPriceById(priceId)),
    );
  }
}
