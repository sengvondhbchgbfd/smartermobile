import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAll();
  Future<CategoryModel> getById(int categoryId);
  Future<CategoryModel> create({required String categoryName, File? image});
  Future<CategoryModel> update({
    required int categoryId,
    String? categoryName,
    File? image,
  });
  Future<void> deleteImage(int categoryId);
  Future<void> delete(int categoryId);
}

///////////////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////////////

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient _dioClient;
  CategoryRemoteDataSourceImpl(this._dioClient);
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
  Future<List<CategoryModel>> getAll() async {
    try {
      final res = await _dio.get(ApiEndpoints.categories);
      return (res.data as List).map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<CategoryModel> getById(int categoryId) async {
    try {
      return CategoryModel.fromJson(
        (await _dio.get(ApiEndpoints.categoryById(categoryId))).data,
      );
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<CategoryModel> create({
    required String categoryName,
    File? image,
  }) async {
    try {
      final form = FormData.fromMap({
        'category_name': categoryName,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });

      return CategoryModel.fromJson(
        (await _dio.post(ApiEndpoints.categories, data: form)).data,
      );
    } on DioException catch (e) {
      _throw(e);
    }
  }



  @override
  Future<CategoryModel> update({
    required int categoryId,
    String? categoryName,
    File? image,
  }) async {
    try {
      final form = FormData.fromMap({
        if (categoryName != null) 'category_name': categoryName,
        if (image != null) 'image': await MultipartFile.fromFile(image.path),
      });
      return CategoryModel.fromJson(
        (await _dio.patch(
          ApiEndpoints.categoryById(categoryId),
          data: form,
        )).data,
      );
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> deleteImage(int categoryId) async {
    try {
      await _dio.delete(ApiEndpoints.categoryImage(categoryId));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> delete(int categoryId) async {
    try {
      await _dio.delete(ApiEndpoints.categoryById(categoryId));
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
