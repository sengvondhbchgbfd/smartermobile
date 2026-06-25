import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/features/inventory/invoice/data/models/invoice_item_model.dart';
import '../../domain/repositories/invoice_repository.dart'
    show InvoiceItemInput;

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceModel>> getAll({int? customerId});
  Future<InvoiceModel> getById(int invoiceId);
  Future<InvoiceModel> create({
    int? customerId,
    int? staffId,
    required double totalAmount,
    required double discount,
    required double tax,
    required String paymentType,
    required List<InvoiceItemInput> items,
  });
  Future<InvoiceModel> update({
    required int invoiceId,
    double? totalAmount,
    double? discount,
    double? tax,
    String? paymentType,
  });
  Future<InvoiceAttachmentModel> addAttachment({
    required int invoiceId,
    required File file,
    String? fileType,
  });
  Future<void> deleteAttachment({
    required int invoiceId,
    required int attachmentId,
  });
  Future<void> delete(int invoiceId);
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final DioClient _dioClient;
  static const _path = '/invoices/';

  InvoiceRemoteDataSourceImpl(this._dioClient);
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
  Future<List<InvoiceModel>> getAll({int? customerId}) async {
    try {
      final res = await _dio.get(
        _path,
        queryParameters: {if (customerId != null) 'customer_id': customerId},
      );
      return (res.data as List).map((e) => InvoiceModel.fromJson(e)).toList();
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<InvoiceModel> getById(int invoiceId) async {
    try {
      return InvoiceModel.fromJson((await _dio.get('$_path/$invoiceId')).data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<InvoiceModel> create({
    int? customerId,
    int? staffId,
    required double totalAmount,
    required double discount,
    required double tax,
    required String paymentType,
    required List<InvoiceItemInput> items,
  }) async {
    try {
      final res = await _dio.post(
        _path,
        data: {
          if (customerId != null) 'customer_id': customerId,
          if (staffId != null) 'staff_id': staffId,
          'total_amount': totalAmount,
          'discount': discount,
          'tax': tax,
          'payment_type': paymentType,
          'items': items
              .map(
                (i) => {
                  'product_id': i.productId,
                  'variant_id': i.variantId,
                  'quantity': i.quantity,
                  'unit_price': i.unitPrice,
                },
              )
              .toList(),
        },
      );
      return InvoiceModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<InvoiceModel> update({
    required int invoiceId,
    double? totalAmount,
    double? discount,
    double? tax,
    String? paymentType,
  }) async {
    try {
      final res = await _dio.patch(
        '$_path/$invoiceId',
        data: {
          if (totalAmount != null) 'total_amount': totalAmount,
          if (discount != null) 'discount': discount,
          if (tax != null) 'tax': tax,
          if (paymentType != null) 'payment_type': paymentType,
        },
      );
      return InvoiceModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<InvoiceAttachmentModel> addAttachment({
    required int invoiceId,
    required File file,
    String? fileType,
  }) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        if (fileType != null) 'file_type': fileType,
      });
      final res = await _dio.post('$_path/$invoiceId/attachments', data: form);
      return InvoiceAttachmentModel.fromJson(res.data);
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> deleteAttachment({
    required int invoiceId,
    required int attachmentId,
  }) async {
    try {
      await _dio.delete('$_path/$invoiceId/attachments/$attachmentId');
    } on DioException catch (e) {
      _throw(e);
    }
  }

  @override
  Future<void> delete(int invoiceId) async {
    try {
      await _dio.delete('$_path/$invoiceId');
    } on DioException catch (e) {
      _throw(e);
    }
  }
}
