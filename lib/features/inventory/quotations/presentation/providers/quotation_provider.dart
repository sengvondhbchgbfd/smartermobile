import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_item_entity.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/quotation_remote_datasource.dart';
import '../../data/repositories/quotation_repository_impl.dart';
import '../../domain/entities/quotation_entity.dart';
import '../../domain/repositories/quotation_repository.dart';
import '../../domain/usecase/quotation_usecase.dart';
import 'quotation_filter_provider.dart';

part 'quotation_provider.g.dart';

@riverpod
Future<QuotationRemoteDataSource> quotationRemoteDataSource(
  QuotationRemoteDataSourceRef ref,
) async {
  final dio = await ref.watch(dioProvider.future);
  return QuotationRemoteDataSourceImpl(dio);
}

@riverpod
Future<QuotationRepository> quotationRepository(
  QuotationRepositoryRef ref,
) async {
  final remote = await ref.watch(quotationRemoteDataSourceProvider.future);
  return QuotationRepositoryImpl(remote);
}

@riverpod
Future<QuotationUsecase> quotationUsecase(QuotationUsecaseRef ref) async {
  final repository = await ref.watch(quotationRepositoryProvider.future);
  return QuotationUsecase(repository);
}

// ---------------------------------------------------------------------------
// List — [Manager] all quotations, filterable
// ---------------------------------------------------------------------------

@riverpod
class QuotationListNotifier extends _$QuotationListNotifier {
  @override
  Future<List<QuotationEntity>> build() async {
    final filter = ref.watch(quotationFilterNotifierProvider);
    final usecase = await ref.watch(quotationUsecaseProvider.future);

    final quotations = await usecase.getAll(
      staffId: filter.staffId,
      customerId: filter.customerId,
      status: filter.status,
    );

    if (filter.searchQuery.trim().isEmpty) return quotations;

    final query = filter.searchQuery.trim().toLowerCase();
    return quotations
        .where(
          (q) =>
              q.refNumber.toLowerCase().contains(query) ||
              (q.customerName?.toLowerCase().contains(query) ?? false),
        )
        .toList();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteQuotation(int quotationId) async {
    final usecase = await ref.read(quotationUsecaseProvider.future);
    await usecase.delete(quotationId);
    await refresh();
  }
}

// ---------------------------------------------------------------------------
// Staff — "My Quotations"
// ---------------------------------------------------------------------------

@riverpod
class MyQuotationsNotifier extends _$MyQuotationsNotifier {
  @override
  Future<List<QuotationEntity>> build() async {
    final usecase = await ref.watch(quotationUsecaseProvider.future);
    return usecase.getMyQuotations();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// ---------------------------------------------------------------------------
// Detail — single quotation by id
// ---------------------------------------------------------------------------

@riverpod
class QuotationDetailNotifier extends _$QuotationDetailNotifier {
  @override
  Future<QuotationEntity> build(int quotationId) async {
    final usecase = await ref.watch(quotationUsecaseProvider.future);
    return usecase.getById(quotationId);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> addItem(QuotationItemEntity item) async {
    final repo = await ref.read(quotationRepositoryProvider.future);
    await repo.addItem(
      quotationId,
      sortOrder: item.sortOrder,
      itemName: item.itemName,
      size: item.size,
      pages: item.pages,
      printSide: item.printSide,
      colorSpec: item.colorSpec,
      paperCover: item.paperCover,
      paperInside: item.paperInside,
      finishing: item.finishing,
      language: item.language,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      note: item.note,
      priceTiers: item.priceTiers,
    );
    await refresh();
  }

  Future<void> updateItem(int itemId, QuotationItemEntity item) async {
    final repo = await ref.read(quotationRepositoryProvider.future);
    await repo.updateItem(
      quotationId,
      itemId,
      sortOrder: item.sortOrder,
      itemName: item.itemName,
      size: item.size,
      pages: item.pages,
      printSide: item.printSide,
      colorSpec: item.colorSpec,
      paperCover: item.paperCover,
      paperInside: item.paperInside,
      finishing: item.finishing,
      language: item.language,
      quantity: item.quantity,
      unitPrice: item.unitPrice,
      note: item.note,
      priceTiers: item.priceTiers,
    );
    await refresh();
  }

  Future<void> deleteItem(int itemId) async {
    final repo = await ref.read(quotationRepositoryProvider.future);
    await repo.deleteItem(quotationId, itemId);
    await refresh();
  }
}

// ---------------------------------------------------------------------------
// Summary — dashboard stats
// ---------------------------------------------------------------------------

@riverpod
Future<Map<String, dynamic>> quotationSummary(QuotationSummaryRef ref) async {
  final usecase = await ref.watch(quotationUsecaseProvider.future);
  return usecase.getSummary();
}
