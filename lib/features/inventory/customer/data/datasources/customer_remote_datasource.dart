import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/customer_model.dart';

abstract class CustomerRemoteDataSource {
  Future<List<CustomerModel>> getAll();
  Future<CustomerModel> getById(int customerId);
  Future<CustomerModel> create({
    required String name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  });
  Future<CustomerModel> update({
    required int customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  });
  Future<void> deleteAvatar(int customerId);
  Future<void> delete(int customerId);
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  final DioClient _dioClient;
  CustomerRemoteDataSourceImpl(this._dioClient);
  Dio get _dio => _dioClient.dio;

  Never _throw(DioException e) {
    throw ApiException(
      statusCode: e.response?.statusCode ?? 0,
      message: ApiErrorHandler.getMessage(e),
    );
  }

  @override
  Future<List<CustomerModel>> getAll() async {
    try {
      final res = await _dio.get(ApiEndpoints.customers);
      return (res.data as List).map((e) => CustomerModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<CustomerModel> getById(int customerId) async {
    try {
      final res = await _dio.get(ApiEndpoints.customerById(customerId));
      return CustomerModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<CustomerModel> create({
    required String name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  }) async {
    try {
      final form = FormData.fromMap({
        'name': name,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path),
      });
      final res = await _dio.post(ApiEndpoints.customers, data: form);
      return CustomerModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<CustomerModel> update({
    required int customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  }) async {
    try {
      final form = FormData.fromMap({
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
        if (avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path),
      });
      final res = await _dio.patch(
        ApiEndpoints.customerById(customerId),
        data: form,
      );
      return CustomerModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> deleteAvatar(int customerId) async {
    try {
      await _dio.delete(ApiEndpoints.customerAvatar(customerId));
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> delete(int customerId) async {
    try {
      await _dio.delete(ApiEndpoints.customerById(customerId));
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
