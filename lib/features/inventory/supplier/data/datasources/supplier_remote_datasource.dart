import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/supplier_model.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

abstract class SupplierRemoteDataSource {
  Future<List<SupplierModel>> getAll();
  Future<SupplierModel> getById(int supplierId);
  Future<SupplierModel> create({
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  });
  Future<SupplierModel> update({
    required int supplierId,
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  });
  Future<void> deleteAvatar(int supplierId);
  Future<void> delete(int supplierId);
}

////////////////////////////////////////////////////////////////////////////////
/// IMPL
////////////////////////////////////////////////////////////////////////////////

class SupplierRemoteDataSourceImpl implements SupplierRemoteDataSource {
  final DioClient _dioClient;
  SupplierRemoteDataSourceImpl(this._dioClient);
  Dio get _dio => _dioClient.dio;

  Never _throw(DioException e) {
    throw ApiException(
      statusCode: e.response?.statusCode ?? 0,
      message: ApiErrorHandler.getMessage(e),
    );
  }

  @override
  Future<List<SupplierModel>> getAll() async {
    try {
      final res = await _dio.get(ApiEndpoints.suppliers);
      return (res.data as List).map((e) => SupplierModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<SupplierModel> getById(int supplierId) async {
    try {
      final res = await _dio.get(ApiEndpoints.supplierById(supplierId));
      return SupplierModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<SupplierModel> create({
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) async {
    try {
      final form = FormData.fromMap({
        'name': name,
        if (contactPerson != null) 'contact_person': contactPerson,
        if (phone != null) 'phone': phone,
        if (phone2 != null) 'phone': phone,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
        if (avatar != null)
          'avatar': await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
      });
      final res = await _dio.post(ApiEndpoints.suppliers, data: form);
      return SupplierModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<SupplierModel> update({
    required int supplierId,
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) async {
    try {
      final form = FormData.fromMap({
        'name': name,
        if (contactPerson != null) 'contact_person': contactPerson,
        if (phone != null) 'phone': phone,
        if (phone2 != null) 'phone2': phone2,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
        if (avatar != null)
          'avatar': await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
      });
      final res = await _dio.patch(
        ApiEndpoints.supplierById(supplierId),
        data: form,
      );
      return SupplierModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> deleteAvatar(int supplierId) async {
    try {
      await _dio.delete(ApiEndpoints.supplierAvatar(supplierId));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> delete(int supplierId) async {
    try {
      await _dio.delete(ApiEndpoints.supplierById(supplierId));
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
