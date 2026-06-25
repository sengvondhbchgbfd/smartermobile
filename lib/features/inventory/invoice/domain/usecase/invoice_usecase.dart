import 'dart:io';
import '../entities/invoice_entity.dart';
import '../repositories/invoice_repository.dart';

class GetAllInvoicesUseCase {
  final InvoiceRepository _repo;
  const GetAllInvoicesUseCase(this._repo);
  Future<List<InvoiceEntity>> call({int? customerId}) => _repo.getAll(customerId: customerId);
}

class GetInvoiceByIdUseCase {
  final InvoiceRepository _repo;
  const GetInvoiceByIdUseCase(this._repo);
  Future<InvoiceEntity> call(int id) => _repo.getById(id);
}

class CreateInvoiceUseCase {
  final InvoiceRepository _repo;
  const CreateInvoiceUseCase(this._repo);
  Future<InvoiceEntity> call({
    int? customerId,
    int? staffId,
    required double totalAmount,
    required double discount,
    required double tax,
    required String paymentType,
    required List<InvoiceItemInput> items,
  }) =>
      _repo.create(
        customerId: customerId,
        staffId: staffId,
        totalAmount: totalAmount,
        discount: discount,
        tax: tax,
        paymentType: paymentType,
        items: items,
      );
}

class UpdateInvoiceUseCase {
  final InvoiceRepository _repo;
  const UpdateInvoiceUseCase(this._repo);
  Future<InvoiceEntity> call({
    required int invoiceId,
    double? totalAmount,
    double? discount,
    double? tax,
    String? paymentType,
  }) =>
      _repo.update(
        invoiceId: invoiceId,
        totalAmount: totalAmount,
        discount: discount,
        tax: tax,
        paymentType: paymentType,
      );
}

class AddInvoiceAttachmentUseCase {
  final InvoiceRepository _repo;
  const AddInvoiceAttachmentUseCase(this._repo);
  Future<InvoiceAttachmentEntity> call({
    required int invoiceId,
    required File file,
    String? fileType,
  }) =>
      _repo.addAttachment(invoiceId: invoiceId, file: file, fileType: fileType);
}

class DeleteInvoiceAttachmentUseCase {
  final InvoiceRepository _repo;
  const DeleteInvoiceAttachmentUseCase(this._repo);
  Future<void> call({required int invoiceId, required int attachmentId}) =>
      _repo.deleteAttachment(invoiceId: invoiceId, attachmentId: attachmentId);
}

class DeleteInvoiceUseCase {
  final InvoiceRepository _repo;
  const DeleteInvoiceUseCase(this._repo);
  Future<void> call(int id) => _repo.delete(id);
}