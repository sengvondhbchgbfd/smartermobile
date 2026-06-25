import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/features/inventory/product/data/models/product_model.dart';

abstract class ProductVariantRemoteDataSource {
  Future<List<ProductVariantModel>> getAll(int productId);
  Future<ProductVariantModel> getById(int productId, int variantId);

  Future<ProductVariantModel> create({
    required int productId,
    String? sku,
    required Map<String, dynamic> specs,
    required double price,
    required int stockQuantity,
  });

  Future<ProductVariantModel> update({
    required int productId,
    required int variantId,
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
  });
  Future<void> delete(int productId, int variantId);

  Future<ProductImageModel> addImage({
    required int productId,
    required int variantId,
    required File image,
    bool isPrimary,
    int sortOrder,
  });
  Future<ProductImageModel> setPrimaryImage({
    required int productId,
    required int variantId,
    required int imageId,
  });

  Future<void> deleteImage({
    required int productId,
    required int variantId,
    required int imageId,
  });
}

/////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////

class ProductVariantRemoteDataSourceImpl
    implements ProductVariantRemoteDataSource {
  final DioClient _dioClient;
  ProductVariantRemoteDataSourceImpl(this._dioClient);
  Dio get _dio => _dioClient.dio;

  ////////////////////////////////////////////
  // Get Exception Error
  ///////////////////////////////////////////

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

  ////////////////////////////////////////
  ///  Get All
  ///////////////////////////////////////
  @override
  Future<List<ProductVariantModel>> getAll(int productId) async {
    try {
      final res = await _dio.get(ApiEndpoints.productVariants(productId));

      return (res.data as List)
          .map((e) => ProductVariantModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  ////////////////////////////////////
  /// Get By Id
  ///////////////////////////////////

  @override
  Future<ProductVariantModel> getById(int productId, int variantId) async {
    try {
      final res = await _dio.get(
        ApiEndpoints.productVariantById(productId, variantId),
      );
      return ProductVariantModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  //////////////////////////////////
  /// create
  /////////////////////////////////

  @override
  Future<ProductVariantModel> create({
    required int productId,
    String? sku,
    required Map<String, dynamic> specs,
    required double price,
    required int stockQuantity,
  }) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.productVariants(productId),
        data: {
          if (sku != null) 'sku': sku,
          'specs': specs,
          'price': price,
          'stock_quantity': stockQuantity,
        },
      );
      return ProductVariantModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  //////////////////////////////////////
  /// UPDATE
  //////////////////////////////////
  @override
  Future<ProductVariantModel> update({
    required int productId,
    required int variantId,
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
  }) async {
    try {
      final res = await _dio.patch(
        ApiEndpoints.productVariantById(productId, variantId),
        data: {
          if (sku != null) 'sku': sku,
          if (specs != null) 'specs': specs,
          if (price != null) 'price': price,
          if (stockQuantity != null) 'stock_quantity': stockQuantity,
        },
      );
      return ProductVariantModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  ///////////////////////////////////////
  /// DELETE
  //////////////////////////////////////
  @override
  Future<void> delete(int productId, int variantId) async {
    try {
      await _dio.delete(ApiEndpoints.productVariantById(productId, variantId));
    } on DioException catch (e) {
      _throw(e);
    }
  }
  ////////////////////////////////////
  /// ADD IMAGE
  ///////////////////////////////////

  @override
  Future<ProductImageModel> addImage({
    required int productId,
    required int variantId,
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
        ApiEndpoints.variantImages(productId, variantId),
        data: form,
      );
      return ProductImageModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  //////////////////////////////
  /// SET IMAGE TO PRIMARY
  ////////////////////////////
  @override
  Future<ProductImageModel> setPrimaryImage({
    required int productId,
    required int variantId,
    required int imageId,
  }) async {
    try {
      final res = await _dio.patch(
        ApiEndpoints.variantImageSetPrimary(productId, variantId, imageId),
      );
      return ProductImageModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  /////////////////////////////////////
  /// DELETEIMAGE
  ///////////////////////////////////

  @override
  Future<void> deleteImage({
    required int productId,
    required int variantId,
    required int imageId,
  }) async {
    try {
      await _dio.delete(
        ApiEndpoints.variantImageById(productId, variantId, imageId),
      );
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
