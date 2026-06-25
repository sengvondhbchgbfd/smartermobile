import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAll({int? categoryId});
  Future<ProductModel> getById(int productId);

  Future<ProductModel> create({
    required String name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity → now on variant
  });

  Future<ProductModel> update({
    required int productId,
    String? name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity → now on variant
  });

  Future<ProductImageModel> addImage({
    required int productId,
    required File image,
    bool isPrimary,
    int sortOrder,
  });

  Future<ProductImageModel> setPrimaryImage({
    required int productId,
    required int imageId,
  });

  Future<void> deleteImage({required int productId, required int imageId});
  Future<void> delete(int productId);
}

////////////////////////////////////////////////////////////////////////////////

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;
  static const _path = ApiEndpoints.products;
  ProductRemoteDataSourceImpl(this._dioClient);
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
  Future<List<ProductModel>> getAll({int? categoryId}) async {
    try {
      final res = await _dio.get(
        _path,
        queryParameters: {if (categoryId != null) 'category_id': categoryId},
      );
      return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<ProductModel> getById(int productId) async {
    try {
      final res = await _dio.get(ApiEndpoints.productById(productId));
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<ProductModel> create({
    required String name,
    int? categoryId,
    String? description,
  }) async {
    try {
      final res = await _dio.post(
        _path,
        data: {
          'name': name,
          if (categoryId != null) 'category_id': categoryId,
          if (description != null) 'descriptions': description,
          // ✅ removed: price, unit, length_width, stock_quantity
        },
      );
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<ProductModel> update({
    required int productId,
    String? name,
    int? categoryId,
    String? description,
  }) async {
    try {
      final res = await _dio.patch(
        ApiEndpoints.productById(productId),
        data: {
          if (name != null) 'name': name,
          if (categoryId != null) 'category_id': categoryId,
          if (description != null) 'descriptions': description,
          // ✅ removed: price, unit, length_width, stock_quantity
        },
      );
      return ProductModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<ProductImageModel> addImage({
    required int productId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) async {
    try {
      final form = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
        'is_primary': isPrimary,
        'sort_order': sortOrder,
      });
      final res = await _dio.post(
        ApiEndpoints.productImages(productId),
        data: form,
      );
      return ProductImageModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<ProductImageModel> setPrimaryImage({
    required int productId,
    required int imageId,
  }) async {
    try {
      final res = await _dio.patch(
        ApiEndpoints.productImageSetPrimary(productId, imageId),
      );
      return ProductImageModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> deleteImage({
    required int productId,
    required int imageId,
  }) async {
    try {
      await _dio.delete(ApiEndpoints.productImageById(productId, imageId));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> delete(int productId) async {
    try {
      await _dio.delete(ApiEndpoints.productById(productId));
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
