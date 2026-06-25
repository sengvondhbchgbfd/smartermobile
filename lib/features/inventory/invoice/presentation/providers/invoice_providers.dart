import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/invoice/data/datasource/invoice_remote_datasource.dart';
import 'package:frontendmobile/features/inventory/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/usecase/invoice_usecase.dart';
export '../../domain/repositories/invoice_repository.dart'
    show InvoiceItemInput;

part 'invoice_providers.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

@riverpod
Future<InvoiceRemoteDataSource> invoiceDataSource(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return InvoiceRemoteDataSourceImpl(dioClient);
}

@riverpod
Future<InvoiceRepository> invoiceRepository(Ref ref) async {
  final ds = await ref.watch(invoiceDataSourceProvider.future);
  return InvoiceRepositoryImpl(ds);
}

// ── Use-case providers ─────────────────────────────────────────────────────────

@riverpod
Future<GetAllInvoicesUseCase> getAllInvoicesUC(Ref ref) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return GetAllInvoicesUseCase(repo);
}

@riverpod
Future<GetInvoiceByIdUseCase> getInvoiceByIdUC(Ref ref) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return GetInvoiceByIdUseCase(repo);
}

@riverpod
Future<CreateInvoiceUseCase> createInvoiceUC(Ref ref) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return CreateInvoiceUseCase(repo);
}

@riverpod
Future<UpdateInvoiceUseCase> updateInvoiceUC(Ref ref) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return UpdateInvoiceUseCase(repo);
}

@riverpod
Future<AddInvoiceAttachmentUseCase> addInvoiceAttachmentUC(Ref ref) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return AddInvoiceAttachmentUseCase(repo);
}

@riverpod
Future<DeleteInvoiceAttachmentUseCase> deleteInvoiceAttachmentUC(
  Ref ref,
) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return DeleteInvoiceAttachmentUseCase(repo);
}

@riverpod
Future<DeleteInvoiceUseCase> deleteInvoiceUC(Ref ref) async {
  final repo = await ref.watch(invoiceRepositoryProvider.future);
  return DeleteInvoiceUseCase(repo);
}

// ── Notifier ────────────────────────────────────────────────────────────────

@riverpod
class InvoiceNotifier extends _$InvoiceNotifier {
  @override
  InvoiceState build() => const InvoiceState();

  Future<GetAllInvoicesUseCase> get _getAllUC =>
      ref.read(getAllInvoicesUCProvider.future);
  Future<CreateInvoiceUseCase> get _createUC =>
      ref.read(createInvoiceUCProvider.future);
  Future<UpdateInvoiceUseCase> get _updateUC =>
      ref.read(updateInvoiceUCProvider.future);
  Future<AddInvoiceAttachmentUseCase> get _addAttachmentUC =>
      ref.read(addInvoiceAttachmentUCProvider.future);
  Future<DeleteInvoiceAttachmentUseCase> get _deleteAttachmentUC =>
      ref.read(deleteInvoiceAttachmentUCProvider.future);
  Future<DeleteInvoiceUseCase> get _deleteUC =>
      ref.read(deleteInvoiceUCProvider.future);

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadAll({int? customerId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uc = await _getAllUC;
      final result = await uc(customerId: customerId);
      state = state.copyWith(invoices: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────
  // Note: backend auto-deducts product stock for each item

  Future<bool> create({
    int? customerId,
    int? staffId,
    required double totalAmount,
    required double discount,
    required double tax,
    required String paymentType,
    required List<InvoiceItemInput> items,
  }) async {
    state = state.copyWith(isCreating: true, error: null);
    try {
      final uc = await _createUC;
      final created = await uc(
        customerId: customerId,
        staffId: staffId,
        totalAmount: totalAmount,
        discount: discount,
        tax: tax,
        paymentType: paymentType,
        items: items,
      );
      state = state.copyWith(
        invoices: [created, ...state.invoices],
        isCreating: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message, isCreating: false);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreating: false);
      return false;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> update({
    required int invoiceId,
    double? totalAmount,
    double? discount,
    double? tax,
    String? paymentType,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, invoiceId},
      error: null,
    );
    try {
      final uc = await _updateUC;
      final updated = await uc(
        invoiceId: invoiceId,
        totalAmount: totalAmount,
        discount: discount,
        tax: tax,
        paymentType: paymentType,
      );
      state = state.copyWith(
        invoices: state.invoices
            .map((i) => i.invoiceId == invoiceId ? updated : i)
            .toList(),
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: "Connect timout. Please try again",
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    }
  }

  // ── Add attachment ────────────────────────────────────────────────────────

  Future<bool> addAttachment({
    required int invoiceId,
    required File file,
    String? fileType,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, invoiceId},
      error: null,
    );
    try {
      final uc = await _addAttachmentUC;
      await uc(invoiceId: invoiceId, file: file, fileType: fileType);
      await loadAll();
      state = state.copyWith(
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    }
  }

  // ── Delete attachment ─────────────────────────────────────────────────────

  Future<bool> deleteAttachment({
    required int invoiceId,
    required int attachmentId,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, invoiceId},
      error: null,
    );
    try {
      final uc = await _deleteAttachmentUC;
      await uc(invoiceId: invoiceId, attachmentId: attachmentId);
      state = state.copyWith(
        invoices: state.invoices.map((inv) {
          if (inv.invoiceId != invoiceId) return inv;
          return InvoiceEntity(
            invoiceId: inv.invoiceId,
            companyId: inv.companyId,
            customerId: inv.customerId,
            staffId: inv.staffId,
            totalAmount: inv.totalAmount,
            discount: inv.discount,
            tax: inv.tax,
            paymentType: inv.paymentType,
            items: inv.items,
            attachments: inv.attachments
                .where((a) => a.attachmentId != attachmentId)
                .toList(),
            createdAt: inv.createdAt,
            updatedAt: inv.updatedAt,
          );
        }).toList(),
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> delete(int invoiceId) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, invoiceId},
      error: null,
    );
    try {
      final uc = await _deleteUC;
      await uc(invoiceId);
      state = state.copyWith(
        invoices: state.invoices
            .where((i) => i.invoiceId != invoiceId)
            .toList(),
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({invoiceId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
