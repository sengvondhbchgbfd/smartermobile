import 'dart:io';
import 'package:frontendmobile/features/inventory/invoice/data/datasource/invoice_remote_datasource.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remote;
  const InvoiceRepositoryImpl(this._remote);

  @override
  Future<List<InvoiceEntity>> getAll({int? customerId}) => _remote.getAll(customerId: customerId);

  @override
  Future<InvoiceEntity> getById(int id) => _remote.getById(id);

  @override
  Future<InvoiceEntity> create({
    int? customerId,
    int? staffId,
    required double totalAmount,
    required double discount,
    required double tax,
    required String paymentType,
    required List<InvoiceItemInput> items,
  }) =>
      _remote.create(
        customerId: customerId,
        staffId: staffId,
        totalAmount: totalAmount,
        discount: discount,
        tax: tax,
        paymentType: paymentType,
        items: items,
      );

  @override
  Future<InvoiceEntity> update({
    required int invoiceId,
    double? totalAmount,
    double? discount,
    double? tax,
    String? paymentType,
  }) =>
      _remote.update(
        invoiceId: invoiceId,
        totalAmount: totalAmount,
        discount: discount,
        tax: tax,
        paymentType: paymentType,
      );

  @override
  Future<InvoiceAttachmentEntity> addAttachment({
    required int invoiceId,
    required File file,
    String? fileType,
  }) =>
      _remote.addAttachment(invoiceId: invoiceId, file: file, fileType: fileType);

  @override
  Future<void> deleteAttachment({required int invoiceId, required int attachmentId}) =>
      _remote.deleteAttachment(invoiceId: invoiceId, attachmentId: attachmentId);

  @override
  Future<void> delete(int id) => _remote.delete(id);
}